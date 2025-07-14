
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


### Restore messed-up `<CR>` in terminal 

Sometimes control characters mess up with `<CR>` in the terminal output and all
outputs from commands appear on one line. This happens to me, for example, when
exiting a ncurses pinentry with `<C-c>`. To fix this:

 1. Type `<C-c>`;
 2. Run `reset`.

See [here](https://askubuntu.com/a/58049) for more details.


### Enable Network Time Protocol (NTP) 

The easiest way to do it on most systemd-based installations is:

```sh
# Run with root permission
timedatectl set-ntp true
```

More on the [Arch
Wiki](https://wiki.archlinux.org/title/Systemd-timesyncd#Enable_and_start) and
on [System Time](https://wiki.archlinux.org/title/System_time).


