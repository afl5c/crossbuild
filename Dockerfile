FROM ubuntu:xenial

RUN set -x; echo 'Installing Linux build tools...' \
	&& apt update \
	&& apt install -y build-essential libx11-dev libgl1-mesa-dev

RUN set -x; echo 'Installing Windows build tools...' \
	&& apt install -y mingw-w64

WORKDIR /root/raspberry
RUN set -x; echo 'Installing Raspberry Pi build tools...' \
	&& apt install -y wget unzip \
	&& wget https://github.com/raspberrypi/tools/archive/refs/heads/master.zip \
	&& unzip master.zip \
	&& mv tools-master/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/ . \
	&& rm -rf master.zip tools-master/

WORKDIR /root/osxcross
RUN set -x; echo 'Installing Mac build tools...' \
	&& wget https://github.com/tpoechtrager/osxcross/archive/refs/heads/master.zip \
	&& unzip master.zip \
	&& cd osxcross-master/tarballs/ \
	&& wget https://www.dropbox.com/s/yfbesd249w10lpc/MacOSX10.10.sdk.tar.xz \
	&& cd .. \
	&& apt install -y clang cmake git python libssl-dev lzma-dev libxml2-dev \
	&& echo "" | ./build.sh \
	&& apt install -y gcc g++ zlib1g-dev libmpc-dev libmpfr-dev libgmp-dev \
	&& ./build_gcc.sh \
	&& mv target/ .. \
	&& cd .. \
	&& rm -rf master.zip osxcross-master/

WORKDIR /root/android
RUN set -x; echo 'Installing Android build tools...' \
	&& wget https://dl.google.com/android/repository/android-ndk-r24-linux.zip \
	&& unzip android-ndk-r24-linux.zip \
	&& rm -rf android-ndk-r24-linux.zip

RUN echo 'Creating shortcuts...' \
	&& printf '#!/bin/bash\n\nx86_64-w64-mingw32-gcc $*' > /usr/local/bin/win-gcc \
	&& printf '#!/bin/bash\n\nx86_64-w64-mingw32-g++ $*' > /usr/local/bin/win-g++ \
	&& printf '#!/bin/bash\n\n/root/raspberry/arm-rpi-4.9.3-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc $*' > /usr/local/bin/rpi-gcc \
	&& printf '#!/bin/bash\n\n/root/raspberry/arm-rpi-4.9.3-linux-gnueabihf/bin/arm-linux-gnueabihf-g++ $*' > /usr/local/bin/rpi-g++ \
	&& printf '#!/bin/bash\n\nPATH=/root/osxcross/target/bin/:/root/osxcross/target/libexec/as/x86_64/:${PATH} \
		LD_LIBRARY_PATH=/root/osxcross/target/lib:${LD_LIBRARY_PATH} \
		o64-gcc $*' > /usr/local/bin/mac-gcc \
	&& printf '#!/bin/bash\n\nPATH=/root/osxcross/target/bin/:/root/osxcross/target/libexec/as/x86_64/:${PATH} \
		LD_LIBRARY_PATH=/root/osxcross/target/lib:${LD_LIBRARY_PATH} \
		o64-g++ $*' > /usr/local/bin/mac-g++ \
	&& printf '#!/bin/bash\n\n/root/android/android-ndk-r24/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android30-clang $*' > /usr/local/bin/and-gcc \
	&& printf '#!/bin/bash\n\n/root/android/android-ndk-r24/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android30-clang++ $*' > /usr/local/bin/and-g++ \
	&& chmod 755 /usr/local/bin/*-g*

WORKDIR /workspace
