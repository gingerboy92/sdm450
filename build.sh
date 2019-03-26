#! /bin/sh
#
# Copyright (C) 2019 Raphielscape LLC.
#
# Licensed under the Raphielscape Public License, Version 1.0 (the "License");
# you may not use this file except in compliance with the License.
#
# Kernel building script.

sudo chmod -R 777 scripts/fetch-latest-wireguard.sh
BUILD_DATE=" $(date +%Y-%m-%d-%H%M)
FILE_NAME=Nano_Kernel-rosy-$BUILD_DATE.zip

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

TELEGRAM_TOKEN=${BOT_API_KEY}
export BOT_API_KEY PARSE_BRANCH PARSE_ORIGIN COMMIT_POINT TELEGRAM_TOKEN
. "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"/stacks/telegram
kickstart_pub
function clone {
	git clone --depth=1 --no-single-branch https://github.com/shreejoy/Toolchain Toolchain
	git clone --depth=1 --no-single-branch https://github.com/shreejoy/AnyKernel2 anykernel2
    git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 gcc4.9
}

function exports {
	export KBUILD_BUILD_USER="shreejoy"
	export KBUILD_BUILD_HOST="nano-ci"
	export ARCH=arm64
	export SUBARCH=arm64
        PATH=$KERNEL_DIR/Toolchain/bin:$PATH
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
	CROSS_COMPILE="$KERNEL_DIR/Toolchain/bin/aarch64-linux-android-" 
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
function push {
        scp $FILE_NAME pshreejoy15@frs.sourceforge.net:/home/frs/p/shreejoy
	}

function gen_zip {
	if [ -f $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb ]
	then 
		echo "Zipping Files.."
		mv $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb anykernel2/Image.gz-dtb
		mv anykernel2/Image.gz-dtb anykernel2/zImage
		cd anykernel2
		zip -r $FILE_NAME * -x .git README.md zipsigner-3.0.jar Nano_Kernel-rosy.zip
		fin
		push
		cd ..
        fi
}
tg_senderror() {
    tg_sendinfo "‼️ Build Throwing Error(s)" \
    "@AndroidPie9 check the errors 🛑 "
     tg_debugcast "‼️ Build Throwing Error(s)"
     exit 1
}

tg_yay() {
    tg_sendinfo "✅ Build successfully completed"
}

# Fin Prober
fin() {
    echo "Nano kernel build completed in $((DIFF / 60)) minute(s) and $((DIFF % 60)) seconds.~"
    tg_sendinfo "Nano kernel build completed 😃 in $((DIFF / 60)) minute(s) and $((DIFF % 60)) seconds"
    tg_yay
}
finerr() {
    echo "My works took $((DIFF / 60)) minute(s) and $((DIFF % 60)) seconds but it's error..."
    tg_sendinfo "Build for rosy took $((DIFF / 60)) minute(s) and $((DIFF % 60)) seconds" \
                " " \
                "❌ but it's having some error "
    tg_senderror
    exit 1
}
clone
exports
build_kernel
check_img
