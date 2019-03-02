## "doge kernel" pie tree for Xiaomi Redmi 5 [rosy]

### Kernel source
This 3.18.x kernel tree is based on Pie branch of CAF source with changes necessary for rosy.

##### Submodules
Prima wlan driver, is added as submodule from [android_vendor_qcom_opensource_wlan_prima's](https://github.com/khusika/android_vendor_qcom_opensource_wlan_prima) repo's `wlan-driver.lnx.1.0.r30-rel` branch.

sdFAT filesystem support, is added as submodule from [kernel-sdfat's](https://github.com/cryptomilk/kernel-sdfat) repo's `main` branch.

### Cloning
`git clone --recursive https://github.com/LinuxPanda/android_kernel_rosy.git -b p-318`

The `--recursive` command is required to clone the submodule repos too.

If you missed the `--recursive` command while cloning this repo, then use `git submodule update --init --recursive` to clone all the submodule repos.

### Building
Please build using `rosy-doge_defconfig`

### Bugs
None

### Credits
Huge Thanks to [@nathanchance](https://github.com/nathanchance) for creating & maintaining the `android-linux-stable` repo.

Thanks to [@khusika](https://github.com/khusika) for the `android_vendor_qcom_opensource_wlan_prima` repo.

Thanks to [@cryptomilk](https://github.com/cryptomilk) for the `kernel-sdfat` repo.
