
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


### Preserve colors when redirecting program output

Some commands have an option for this; e.g. `ls --color=always`. Otherwise,
prepend `unbuffer` to the command:

```sh
#                   v "auto", not "always"
unbuffer ls --color=auto | less -R
```

On Arch, install `extra/expect`. Also note that `alias`es won't be executed by
`unbuffer`. See [here](https://superuser.com/a/751809).

### Open and verify `.p7m` files

Sometimes AEcI sends me `.p7m` files.  I can extract them with:

```sh
openssl smime -verify -noverify -binary -in file.pdf.p7m -inform DER -out file.pdf
```

But I'm not able to verify the signature locally.  To do this, use
<https://vol.ca.notariato.it/it>.


### Dead keys on `us-int` keyboard

Here you are the Windows-specific layout:

![](https://en.wikipedia.org/wiki/QWERTY#/media/File:KB_US-International.svg)

It seems to work correctly on Linux as well.  More details can be found on
[Wikipedia](https://en.wikipedia.org/wiki/QWERTY#US-International).  I couldn't
find anything Linux specific, i.e. any map of the so-called _international_ (or
_exended_) keyboard, which should extend the layout map above.
