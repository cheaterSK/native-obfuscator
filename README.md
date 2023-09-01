# native-obfuscator
### DISCLAIMER: This is only an updated and automated fork, all credits for transpilation go to [radioegor146](https://github.com/radioegor146) <3

Java .class to .cpp converter for use with JNI

Warning: blacklist/whitelist usage is recommended, because this tool slows down code significantly (like do not obfuscate full minecraft .jar)

Also, this tool does not particulary obfuscates your code, it just transpiles it to native. Remember to use protectors like VMProtect, Themida or obfuscator-llvm (in case of clang usage)

---
### To run this tool you need to have this installed:
1. JDK 11
    - For Windows:
        I recommend downloading Eclipse Temurin, download [here](https://adoptium.net/temurin/releases/?variant=openjdk11&os=windows&arch=x64&package=jdk).
    - For Linux/MacOS:
        Google "your distro install jdk 8", and install required packages, though I recommend using [SDKMAN](https://sdkman.io/) for this.
2. Zig
    - This should be included next to the .jar, link to download [here](https://ziglang.org/download/).
---

### General usage:
```
Usage: native-obfuscator [-ahV] [-b=<blackListFile>] [-l=<librariesDirectory>]
                         [-p=<platform>] [--plain-lib-name=<libraryName>]
                         [-w=<whiteListFile>] <jarFile> <outputDirectory>
Transpiles .jar file into .cpp files and generates output .jar file
      <jarFile>           Jar file to transpile
      <outputDirectory>   Output directory
  -a, --annotations       Use annotations to ignore/include native obfuscation
  -b, --black-list=<blackListFile>
                          File with list of blacklist classes/methods for
                            transpilation
  -h, --help              Show this help message and exit.
  -l, --libraries=<librariesDirectory>
                          Directory for dependent libraries
  -p, --platform=<platform>
                          Target platform: hotspot - standard standalone
                            HotSpot JRE, std_java - java standard (as for
                            Android)
      --plain-lib-name=<libraryName>
                          Plain library name for LoaderPlain
  -V, --version           Print version information and exit.
  -w, --white-list=<whiteListFile>
                          File with list of whitelist classes/methods for
                            transpilation
```

#### Arguments:
`<jarFile>` - input .jar file to obfuscate

`<outputDirectory>` - output directory where C++/new .jar file where be created

`-l <librariesDirectory>` - directory where dependant libraries should be, optional, but preferable

`-p <platform>` - JVM platform on what library will be executed

Two options are available:
    - hotspot: will use HotSpot JVM internals and should work with most obfuscators (even with stack trace checking as well)
    - std_java: will use only minor JVM internals that are available on Android as well. Use only this option if you want to run your library on Android

`-a` - enable annotation processing

To use annotations for black/whitelisting methods/classes as `native` you can add following library to your project:

`com.github.radioegor146.native-obfuscator:annotations:master-SNAPSHOT`

Also, you need to add [JitPack](https://jitpack.io) to your repositories.

You can add `@Native` annotation to include classes/methods to the native obfuscation process, and add `@NotNative` annotation to ignore methods in classes marked as `@Native`

Whitelist/Blacklist has higher priority than annotations

`-w <whiteList>` - path to .txt file for whitelist of methods and classes if required

`-b <blackList>` - path to .txt file for blacklist of methods and classes if required

Both of them should come in such form:
```
<class>
<class>#<method name>#<method descriptor>
mypackage/myotherpackage/Class1
mypackage/myotherpackage/Class1#doSomething!()V
mypackage/myotherpackage/Class1$SubClass#doOther!(I)V
```
It uses internal names of classes and method descriptors for filtering (you can read more about it by googling "java internal class names" or "java method descriptors")

Also, you can use wildcard matchers like this:
```
mypackage/myotherpackage/*
mypackage/myotherpackagewithnested/**
mypackage/myotherpackage/*/Class1
mypackage/myotherpackagewithnested/**/Class1
mypackage/myotherpackage/Class*
```
`*` matches single entry (divided by `/`) in class/package name

`**` matches all entries in class/package name

#### Basic usage:
// todo

---

### Building the tool by yourself
1. Run `./gradlew shadowJar`

---

In case of any problems feel free to open an issue.
