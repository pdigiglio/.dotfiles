## Troubleshooting


### libva error: /usr/lib/dri/nvidia_drv_video.so init failed with AMD/nvidia

[issue] Apparently, no solution.
See [here](https://github.com/elFarto/nvidia-vaapi-driver/issues/160).

### Asian fonts

Just install any of the fonts that are recommended here (e.g. `noto-fonts-cjk`
is fine):

<https://wiki.archlinux.org/title/Fonts#Chinese,_Japanese,_Korean,_Vietnamese>

And Chromium/Kitty will pick them up on the next session.

### Mount `btrfs` disk and give it user permissions

Mount options like `uid` and `gid` are ignored by `btrfs`. Assuming the
following line in `fstab` exists for the device:

```
# fstab
UUID=<uid>  /mnt/extreme-ssd  btrfs  rw,relatime,ssd,discard=async,space_cache=v2,noauto  0  0
```

You have to mount the disk and give it user permissions:

```sh
sudo mount /mnt/extreme-ssd
sudo chown -R $USER:$USER /mnt/extreme-ssd
```

Note that mount option `users` allows every user to mount the disk (not only
_root_) but it _does not_ give user permissions to the disk. See
[here](https://www.reddit.com/r/btrfs/comments/j5jaby/how_to_automount_btrfs_with_user_permission/).


### High CPU usage from `irq/9-acpi`

Check the interrupts in `/sys/firmware/acpi/interrupts`:

```sh
find /sys/firmware/acpi/interrupts -exec echo -n "{}:" \; -exec cat "{}" \;
# or
grep . -r /sys/firmware/acpi/interrupts
```

And look for a big number. Then mask it:

```sh
# NOTE: GPE is "general purpose event" that ACPI handles.
# See: https://wiki.ubuntu.com/Kernel/Reference/ACPITricksAndTips
sudo echo "mask" >> /sys/firmware/acpi/interrupts/gpe17
```

I found the solution [here](https://forum.manjaro.org/t/irq-9-acpi-is-killing-my-system/176107/13).

***Questions:***

 * Why does this happen?

 * How can I know `gpe17` is related to `irq/9-acpi`?

