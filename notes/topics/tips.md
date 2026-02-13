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

![](https://upload.wikimedia.org/wikipedia/commons/thumb/2/22/KB_US-International.svg/1920px-KB_US-International.svg.png)

It seems to work correctly on Linux as well.  More details can be found on
[Wikipedia](https://en.wikipedia.org/wiki/QWERTY#US-International).  I couldn't
find anything Linux specific, i.e. any map of the so-called _international_ (or
_exended_) keyboard, which should extend the layout map above.


### `grep`

To search recursively:

```sh
grep -R "pattern" /some/path

# You may want to use:
#  --exclude=<glob>
#    Skip subfiles whose base name matches <glob>.
#
#  --exclude-dir=<glob>
#    Skip dirs whose name suffix match <glob>.
#
#  --include=<glob>
#    Search files whose basename match <glob>.
```

From `man grep(1)`:

  - _Name suffix_ is either:

    - The whole name, or

    - A trailing part that starts with a non-slash character immediately after
    a slash (/) in the name. 

  - _Base name_ is the part after the last slash.

To get only the name of the files that contain a match, use `-l` (or
`--files-with-matches`).

This may be useful to get a list of possibly interesting files to be checked by
a text editor; e.g.:

```bash
nvim $(grep -l -R "pattern" .)
```


### `ly` display manager

After an update of [Ly](https://github.com/fairyglade/ly), at least since
`1.3.0`, the display manger would not start---or maybe  it doesn't start in a
deterministic way; I can't say.

The [`README.md`](https://github.com/fairyglade/ly?tab=readme-ov-file#systemd),
says that `ly` conflicts with `getty@tty?.service`.  Both are active and
running:
  

```bash
systemctl list-units "*tty[[:digit:]]*"
```
```txt
  UNIT               LOAD   ACTIVE SUB     DESCRIPTION
  getty@tty1.service loaded active running Getty on tty1
  ly@tty1.service    loaded active running TUI display manager
```

So I do:

```bash
systemctl disable getty@tty1.service
```

> **Note:**
>
> By listing units that match `"*logind*"` I see `systemd-logind.service`
> running.  It will spawn instances of `getty@tty?.service` on demand when
> switching to a different v-console.  I don't want to start `ly` on other
> v-consoles so I don't need to do anything else.
> 
> Anyway `man 5 logind.conf`, entry for _ReserveVT_, says `tty6` will _always_
> be reserved for `getty` login.
>
> I also see `systemd-logind-varlink.socket`.  Varlink is a protocol for IPC.
