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


### JetBrains (Rider)

Run with the following flags (more info [here](https://blog.jetbrains.com/platform/2024/07/wayland-support-preview-in-2024-2/)):

```
-Dawt.toolkit.name=WLToolkit
```

I tried this but I can't see the mouse cursor while hovering on Rider's window
(see [JBR-8223](https://youtrack.jetbrains.com/issue/JBR-8223/Pure-Wayland-on-Arch-Hyprland-no-cursor)).
[This](https://youtrack.jetbrains.com/issue/JBR-8223/Pure-Wayland-on-Arch-Hyprland-no-cursor#focus=Comments-27-11649983.0-0)
comment suggests a workaraund:

```
# File: ~/.config/hypr/hyprland.conf
cursor {
  # Both 1 and 2 seem to work. It makes no sense because 2 should be the
  # default value.
  no_hardware_cursors = 2
}
```
