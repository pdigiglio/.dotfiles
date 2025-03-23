---

Some notes about my Arch setup. Look for `[issue]` to see all the pending issues.

## Getting rid of XWayland

### Electron

Set environment variable
[`ELECTRON_OZONE_PLATFORM_HINT`](https://www.electronjs.org/docs/latest/api/environment-variables#electron_ozone_platform_hint-linux)
to `wayland` or `auto`.

#### [`teams-for-linux`](https://github.com/IsmaelMartinez/teams-for-linux)

When starting `teams-for-linux` (v1.12.7) at Hyprland startup, no tray icon
appears in Waybar. Setting `--trayIconEnabled` did not help. Invoking it with a
delay seems to do the trick:

```
# File: ~/.config/hypr/hyprland.conf
exec-once = sleep 1 && teams-for-linux
```


#### Chromium

Chromium doesn't seem to care about `ELECTRON_OZONE_PLATFORM_HINT`. Run it with the following flag:

```
--ozone-platform-hint=auto
```

If this flag doesn't seem to have any effect, close _all_ the chromium
instances and re-launch it. You can also set this flag in 

```
~/.config/chromium-flags.conf
```

See [Arch Wiki](https://wiki.archlinux.org/title/Chromium).


## Troubleshooting


### libva error: /usr/lib/dri/nvidia_drv_video.so init failed with AMD/nvidia

[issue] Apparently, no solution.
See [here](https://github.com/elFarto/nvidia-vaapi-driver/issues/160).
