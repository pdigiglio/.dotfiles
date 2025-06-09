## `top`

The config file for `top` is stored in:

```
~/.config/procps/toprc
```

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
