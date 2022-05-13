
# Crossbuild

A Docker image for compiling to the following targets:

 - Linux, Intel 64-bit
 - Raspberry Pi (Raspbian), ARM 32-bit
 - Windows (7+), Intel 64-bit
 - MacOS (10.6+), Intel 64-bit
 - Android (11+, NDK 24, API 30), ARM 64-bit

## Differences

This is inspired by [multiarch/crossbuild](https://github.com/multiarch/crossbuild) but not forked from it.
The differences are:

 - Use the official [raspberrypi/tools](https://github.com/raspberrypi/tools) instead of the armhf compiler from apt.
 - Use the official [Android NDK](https://developer.android.com/ndk) instead of the aarch64 compiler from apt.
 - Use the latest MacOS toolchain from [tpoechtrager/osxcross](https://github.com/tpoechtrager/osxcross) instead of an old version.
   Also include the MacOS GCC compilers.
 - Create the image from ubuntu:xenial instead of debian:stretch.
 - Include Linux X11/OpenGL development headers (to be consistent with Mac/Windows).
 - Name the shared volume "workspace" instead of "workdir" to avoid confusion with the WORKDIR (set working directory) Docker command.
 - Instead of setting environment variables, set shortcuts {mac,win,rpi,and}-{gcc,g++}.

## Examples

### Linux

```
g++ hello.cpp
gcc hello.c
```

### Raspberry Pi

```
rpi-g++ hello.cpp
rpi-gcc hello.c
```

### Windows

```
win-g++ hello.cpp
win-gcc hello.c
```

### Mac

```
mac-g++ hello.cpp
mac-gcc hello.c
```

### Android

```
and-g++ hello.cpp
and-gcc hello.c
```
