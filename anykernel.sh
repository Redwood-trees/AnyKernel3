### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=Scarlet-X
kernel.revision=5.4
kernel.compiler=AOSP Clang 17.0.4
kernel.made=Tashar
message.word=Thank you for installing Scarlet-X
do.devicecheck=1
do.modules=1
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=redwood
device.name2=redwoodin
device.name3=lisa
supported.versions=12-14
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties

### AnyKernel install
## boot files attributes
boot_attributes() {
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;
} # end attributes

# begin passthrough patch
passthrough() {
if [ ! "$(getprop persist.sys.fuse.passthrough.enable)" ]; then
	ui_print "Remounting /system as rw..."
	$home/tools/busybox mount -o rw,remount /system
	ui_print "Patching system's build prop for FUSE Passthrough..."
	patch_prop /system/build.prop "persist.sys.fuse.passthrough.enable" "true"
fi
} # end passthrough patch

# boot shell variables
block=boot;
is_slot_device=1;
ramdisk_compression=auto;
patch_vbmeta_flag=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh && passthrough;

# boot install
dump_boot; # use split_boot to skip ramdisk unpack, e.g. for devices with init_boot ramdisk

write_boot; # use flash_boot to skip ramdisk repack, e.g. for devices with init_boot ramdisk
## end boot install

## vendor_boot files attributes
vendor_boot_attributes() {
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;
} # end attributes

# vendor_boot shell variables
block=vendor_boot;
is_slot_device=1;
ramdisk_compression=auto;
patch_vbmeta_flag=auto;

# reset for vendor_boot patching
reset_ak;

# vendor_boot install
#dump_boot; # use split_boot to skip ramdisk unpack, e.g. for dtb on devices with hdr v4 but no vendor_kernel_boot
split_boot;

#write_boot; # use flash_boot to skip ramdisk repack, e.g. for dtb on devices with hdr v4 but no vendor_kernel_boot
flash_boot;

# end vendor_boot install
