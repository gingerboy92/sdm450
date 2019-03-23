#! /bin/sh
#
# Copyright (C) 2018 Raphielscape LLC.
#
# Licensed under the Raphielscape Public License, Version 1.0 (the "License");
# you may not use this file except in compliance with the License.
#
#Kernel building script

KERNEL_DIR=`pwd`
function colors {
	blue='\033[0;34m' cyan='\033[0;36m'
	yellow='\033[0;33m'
	red='\033[0;31m'
	nocol='\033[0m'
}

colors;
PARSE_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
PARSE_ORIGIN="$(git config --get remote.origin.url)"
COMMIT_POINT="$(git log --pretty=format:'%h : %s' -1)"
COMPILER="Linaro-7.3"
TELEGRAM_TOKEN=${BOT_API_KEY}
export BOT_API_KEY PARSE_BRANCH PARSE_ORIGIN COMMIT_POINT TELEGRAM_TOKEN COMPILER
. "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"/stacks/telegram
kickstart_pub

function exports {
	export KBUILD_BUILD_USER="Shreejoy"
	export KBUILD_BUILD_HOST="nano-ci"
	export ARCH=arm64
	export SUBARCH=arm64
        PATH=$KERNEL_DIR/aarch64-linux-gnu/bin:$PATH
	export PATH
}

function build_kernel {
	#better checking defconfig at first
	if [ -f $KERNEL_DIR/arch/arm64/configs/rosy_defconfig ]
	then 
		DEFCONFIG=rosy_defconfig
	elif [ -f $KERNEL_DIR/arch/arm64/configs/rosy_defconfig ]
	then
		DEFCONFIG=rosy_defconfig
	else
		echo "Defconfig Mismatch"
		echo "Exiting in 5 seconds"
		sleep 5
		exit
	fi
CPU="$(grep -c '^processor' /proc/cpuinfo)"
JOBS="$((CPU * 2))"

	make O=out $DEFCONFIG
	BUILD_START=$(date +"%s")
	make -j${JOBS} O=out \
		CROSS_COMPILE="~/kernel_helper/Toolchain/bin/aarch64-linux-gnu-" \
        CROSS_COMPILE_ARM32="~/kernel_helper/gcc4.9/bin/arm-linux-androideabi-"
	BUILD_END=$(date +"%s")
	BUILD_TIME=$(date +"%Y%m%d-%T")
	DIFF=$((BUILD_END - BUILD_START))	
}

function check_img {
	if [ -f $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb ]
	then 
		echo -e "Kernel Built Successfully in $((DIFF / 60)) minute(s) and $((DIFF % 60)) seconds..!!"
		gen_zip
	else 
		finerr
	fi	
}

function gen_zip {
	if [ -f $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb ]
	then 
		echo "Zipping Files.."
		mv $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb ~/anykernel2/Image.gz-dtb
		mv ~/anykernel2/Image.gz-dtb ~/anykernel2/zImage
		cd ~/anykernel2
		zip -r9 "Nano_Kernel-rosy.zip" * -x .git README.md Retarded-Nightly.zip
		fin
		tg_channelcast "Build succeeded, but its an internal build!"
		cd ..
        fi
}
tg_senderror() {
    tg_sendinfo "Build Throwing Error(s)" \
    "@AndroidPie9 have a look at the error"
     tg_channelcast "Build Throwing Error(s)"
     tg_debugcast "Build Throwing Error(s)"
     exit 1
}

tg_yay() {
    tg_sendinfo "Compilation for rosy Completed." \
    "Kernel build is ready"
}

# Fin Prober
fin() {
    echo "Yay! My works took $((DIFF / 60)) minute(s) and $((DIFF % 60)) seconds.~"
    tg_sendinfo "Build for rosy with GCC-7.3 took $((DIFF / 60)) minute(s) and $((DIFF % 60)) seconds"
    tg_channelcast "Build for rosy with GCC-7.3 took $((DIFF / 60)) minute(s) and $((DIFF % 60)) seconds"
    tg_yay
}
finerr() {
    echo "My works took $((DIFF / 60)) minute(s) and $((DIFF % 60)) seconds but it's error..."
    tg_sendinfo "Build for rosy with GCC-7.3 took $((DIFF / 60)) minute(s) and $((DIFF % 60)) seconds" \
                "but it is having error anyways xd"
    tg_senderror
    exit 1
}
exports
build_kernel
check_img
