
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

