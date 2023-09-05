const std = @import("std");

pub fn build(b: *std.build.Builder) !void {
    const lib = b.addSharedLibrary(.{
        .name = "native-obfuscator",
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });
    lib.strip = true;
    lib.force_pic = true;
    lib.linkLibC();
    lib.linkLibCpp();
    lib.addIncludePath(.{
        .path = "/home/cheatersk/.sdkman/candidates/java/17.0.8-amzn/include"
    });
    lib.addIncludePath(.{
        .path = "/home/cheatersk/.sdkman/candidates/java/17.0.8-amzn/include/linux"
    });
    lib.addCSourceFiles(&.{
        "cpp/data_native0_hidden_Hidden0.cpp",
        "cpp/dev_jnic_HelloWorld_0.cpp",
        "cpp/native_jvm.cpp",
        "cpp/native_jvm_output.cpp",
        "cpp/string_pool.cpp"
    }, &.{
        "-std=c++17",

        "-fno-sanitize=all",
        "-fno-sanitize-trap=all",
        "-fno-optimize-sibling-calls",
        "-fvisibility=hidden",
        "-fvisibility-inlines-hidden",
    });

    const target = lib.target_info.target;
    const allocator = std.heap.page_allocator;
    const memory = try allocator.alloc(u8, 100);
    const libName = try std.fmt.allocPrint(allocator, "{s}_{s}{s}", .{ @tagName(target.cpu.arch), @tagName(target.os.tag), target.dynamicLibSuffix() });
    defer allocator.free(memory);

    const install = b.addInstallFileWithDir(lib.getOutputSource(), .{ .custom = "../native0" }, libName);
    install.step.dependOn(&lib.step);
    b.getInstallStep().dependOn(&install.step);
}
