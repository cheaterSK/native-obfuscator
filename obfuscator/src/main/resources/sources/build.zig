const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.build.Builder) !void {
    const allocator = std.heap.page_allocator;
    const memory = try allocator.alloc(u8, 50);
    defer allocator.free(memory);

    const javaHome = try std.process.getEnvVarOwned(allocator, "JAVA_HOME");
    var sources = std.ArrayList([]const u8).init(allocator);
    defer sources.deinit();

    var dir = try std.fs.cwd().openIterableDir("cpp", .{});
    defer dir.close();
    var iterator = dir.iterate();
    while (try iterator.next()) |entry| {
        if (std.mem.endsWith(u8, entry.name, ".cpp")) {
            try sources.append(try std.fmt.allocPrint(allocator, "cpp/{s}", .{ entry.name }));
        }
    }

    const lib = b.addSharedLibrary(.{
        .name = "native-obfuscator",
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{})
    });
    lib.strip = true;
    lib.force_pic = true;
    lib.linkLibC();
    lib.linkLibCpp();
    lib.addIncludePath(.{
        .path = try std.fmt.allocPrint(allocator, "{s}/include", .{ javaHome }),
    });
    lib.addIncludePath(.{
        .path = try std.fmt.allocPrint(allocator, "{s}/include/{s}", .{ javaHome, @tagName(builtin.os.tag) }),
    });
    lib.addCSourceFiles(sources.items, &.{
        "-std=c++17",

        "-fno-sanitize=all",
        "-fno-sanitize-trap=all",
        "-fno-optimize-sibling-calls",
        "-fvisibility=hidden",
        "-fvisibility-inlines-hidden",
    });

    const target = lib.target_info.target;
    const libName = try std.fmt.allocPrint(allocator, "{s}-{s}{s}", .{ @tagName(target.cpu.arch), @tagName(target.os.tag), target.dynamicLibSuffix() });

    const install = b.addInstallFileWithDir(lib.getOutputSource(), .{ .custom = "../native0" }, libName);
    install.step.dependOn(&lib.step);
    b.getInstallStep().dependOn(&install.step);
}