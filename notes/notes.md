---

Some notes about my Arch setup. Look for `[issue]` to see all the pending issues.

## Tips 

### How to tell which distro you're running

Try with:

```sh
cat /etc/*release
```

You may also get lucky and find some info in

```sh
/etc/issue
```

which is used by `agetty`:

```sh
# This may not work.
# E.g. it works on v2.41 but not on v2.30.
agetty --show-issue
```


## `git`

 * List all tags matching a pattern:
   ```sh
   git tag --list 'v1.*'
   ```


## `top`

The config file for `top` is stored in:

```
~/.config/procps/toprc
```

### 


### Interactive usage

Commands that operate on a process (e.g. `k`), will target the first entry in
the task window.

Shortcut | Function 
:-       | :-------
`y`      | Highlight running tasks (i.e. process with status `R`)
`x`      | Highlight current sort column
`z`      | Toggle color/monochrome
`<`      | Sort by column on the left to current column [^top-less-than]
`>`      | Sort by column on the right to current column
`?`      | Show help for interactive commands
`E`      | Change summary memory scale
`e`      | Change task memory scale
`m`      | Cycle through memory display modes
`k`      | Kill process
`0`      | Suppress fields whose value is 0
`c`      | Toggle command line
`1`      | Toggle single/multiple CPU view
`t`      | Cycle through CPU display modes
`i`      | Toggle idle processes
`Z`      | Configure colorscheme
`W`      | Write configuration file
`o`      | Add case-insensitive filter (e.g. `COMMAND=x` for comands _containing_ "x")
`O`      | Add case-sensitive filter
`^O`     | Show current filters
`=`      | Reset filters

See also <https://www.redhat.com/en/blog/customize-top-command>.

[^top-less-than]: <https://superuser.com/a/398870>

### Memory Usage

(See more in section `2c. MEMORY Usage` of `man top`). 

Memory usage is displayed the summary area. It consists of two lines whose
values are read (or evaluated) from `/proc/meminfo` as follows (source fields
in parenthesis):

```
Line 1 reflects physical memory, classified as:
    total          ( MemTotal )
    free           ( MemFree )
    used           ( MemTotal - MemAvailable )
    buff/cache     ( Buffers + Cached + SReclaimable )

Line 2 reflects mostly virtual memory, classified as:
    total          ( SwapTotal )
    free           ( SwapFree )
    used           ( SwapTotal - SwapFree )
    avail          ( MemAvailable, which is physical memory )
```

The `avail` field is an estimation of physical memory available for starting
new applications, without swapping.  Unlike the `free` field, it attempts  to
account  for readily reclaimable page cache and memory slabs.

In the alternate memory display modes, two abbreviated summary lines are shown
consisting of these elements:

```
           a    b          c
GiB Mem : 18.7/15.738   [ ... ]
GiB Swap:  0.0/7.999    [ ... ]
```

Where:

  a. is the percentage used;
  b. is the total available;
  c. is one of two visual graphs of those representations.

For the physical memory,  the  percentage  represents  the  `total` minus  the
estimated  `avail`.   The graph is divided between the non-cached portion of
`used` and any remaining  memory not  otherwise accounted for  by
`avail`.


## `lldb`

https://werat.dev/blog/blazing-fast-expression-evaluation-for-c-in-lldb/

For a cheatsheet, see also: <https://gist.github.com/alanzeino/82713016fd6229ea43a8>

Script collection (and reference to a book): <https://github.com/DerekSelander/LLDB?tab=readme-ov-file>

lldbinit <https://github.com/gdbinit/lldbinit/tree/master?tab=readme-ov-file>

DAP configuration: <https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.lldb-dap>

Retrieve template args of formatters: <https://discourse.llvm.org/t/lldb-sbapi-questions/55899>
 
[issue] Why can I not execute expression involving `this`? <https://bugs.llvm.org/show_bug.cgi?id=41237>
[issue] Reverse debugging?
[issue] Hide local vars that are not yet defined? <https://discourse.llvm.org/t/hiding-local-variables-not-defined-yet/58025>


### Skip code

```
thread jump --by <line-count>
th j -b <line-count>
```

or 

```
thread jump --line <line-count>
```

See: <https://blog.eidinger.info/skip-code-during-debugging-in-xcode>


### Show actual pointer type

```
frame variable -d run-target pObject
```

or

```
expr -d run-target -- pObject
```


See: <https://stackoverflow.com/a/14350239>

### Print pointer as array

```
parray <count> addr

```

See: <https://stackoverflow.com/questions/7062173/view-array-in-lldb-equivalent-of-gdbs-operator-in-xcode-4-1>

### Redirect output to file

```
session save <out-file>
```

See: <https://stackoverflow.com/a/73872850>


## `nvim`

Resurce (about what?): <https://lyz-code.github.io/blue-book/vim_keymaps/>

To use LSP for semantical highlighting: <https://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316>

Working with C#: <https://aaronbos.dev/posts/csharp-dotnet-neovim>


## GNUPlot

##### "Pass" args to a script

There appears to be no way to pass cmd-line args to GNUPlot scripts.
[This](https://gnuplot-info.narkive.com/h0AI295W/command-line-arguments-to-gnuplot-scripts#post2)
post suggests using _here files_ or env vars for this purpose. The flow with
env vars is the following:

```sh
export GNUPLOT_TITLE="title"
gnuplot script.plt
```

You then access those vars within the script via a call to
[`system`](http://gnuplot.info/docs_5.5/loc2100.html):

```plt
# File: script.plt
plot_title = system("echo $GNUPLOT_TITLE")
set title plot_title . " (scale 1:120 cm)"
# ...
```

Also, see [this](http://gnuplot.info/docs/loc3111.html) page for some
documentation on user-defined variables and functions within GNUPlot scripts.


##### Set equal scale on _x_ and _y_

```
set size ratio -1
```

See: <https://stackoverflow.com/a/27546936>

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


## Troubleshooting


### libva error: /usr/lib/dri/nvidia_drv_video.so init failed with AMD/nvidia

[issue] Apparently, no solution.
See [here](https://github.com/elFarto/nvidia-vaapi-driver/issues/160).
