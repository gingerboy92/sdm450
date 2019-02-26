## "doge kernel" pie tree for Xiaomi Redmi 5 [rosy]

### Kernel source
This 3.18.x kernel tree is based on Pie branch of CAF source with changes necessary for rosy.

Prima wlan driver is added as module from [android_vendor_qcom_opensource_wlan_prima's](https://github.com/khusika/android_vendor_qcom_opensource_wlan_prima) `wlan-driver.lnx.1.0.r30-rel` branch.

### Bugs
None

### Building
`git clone --recursive https://github.com/LinuxPanda/android_kernel_rosy.git -b p-318`

The `--recursive` command is required because then only it'll fetch the module trees too.

### Credits
Huge Thanks to [@nathanchance](https://github.com/nathanchance) for creating & maintaining the `android-linux-stable` repo.

Thanks to [@khusika](https://github.com/khusika) for the `android_vendor_qcom_opensource_wlan_prima` repo.
