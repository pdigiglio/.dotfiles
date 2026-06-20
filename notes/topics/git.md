# `git`

## Tips

### List all tags matching a pattern

```bash
git tag --list 'v1.*'
```

### Get latest tag on current branch

```bash
git describe --tags --abbrev=0
```

See [this](https://stackoverflow.com/a/7261049) answer.

### Check if remote branch has been deleted

First, update the remote refs:

```bash
git fetch --prune --all
```

Then get info about the branches:

```bash
git branch -v
```

The output will look like this:

```txt
* master        abcdebf3d17 [behind 581] some commit message
  topic-branch  fghilb32370 [gone] Some other commit message
  [...]
```

You see the remote `topic-branch` was tracking has gone.  See also
[this](https://www.erikschierboom.com/2020/02/17/cleaning-up-local-git-branches-deleted-on-a-remote/)
blog post.

### Search through the logs

To find commits whose message contains pattern _pattern_:

```bash
git log --grep=pattern
# Options:
#  --regexp-ignore-case,-i to make case insensitive
```

To find commits whose patch contains pattern _pattern_:

```bash
git log -Gpattern
# Options:
#  --regexp-ignore-case,-i to make case insensitive
```

To find commits where the number of occurrences of _word_ changed:

```bash
git log -Sword
# Options:
#  --pickaxe-regex         to interpret "word" as a regex
#  --regexp-ignore-case,-i to make case insensitive
```

See [this](https://stackoverflow.com/a/1340245) StackOverflow answer.

### Multiple accounts

If you want to use a specific account for a repository, set it like this:

```ini
# In <repo_path>/.git/config
[user]
    name  = <name>
    email = <email>

# ...
```

### Update submodules after every branch switch

Append this to `.git/hooks/post-checkout`:

```bash
# In .git/hooks/post-checkout
git submodule update --init --recursive
```

### Large file storage

tags: #lfs

Git [LFS](https://git-lfs.com/) takes advantage of hooks and drivers to store
large files in a separate repository and materialize them on
demand[^secret-life-of-git-lfs].  The repo only has to store _pointers_ to
files and their contents is downloaded if and when needed.

The advantage is that you have faster clones at the expense of a (sometimes)
slower checkout.  The space on the server is the same but the space on the
client is potentially less[^why-lfs].

#### Client

- To see which files are tracked via LFS:

  ```bash
  git lfs ls-files 
  ```

  You may want to see the [LFS
  pointers](https://github.com/git-lfs/git-lfs/wiki/Tutorial#lfs-pointer-files-advanced)
  for any such file:

  ```bash
  git show HEAD:$file

  # -- Example output --
  # version https://git-lfs.github.com/spec/v1
  # oid sha256:f05131d24da96daa6a6712c5b9d368c81eeaea5dc7d0b6c7bec7d03ccf021b4a
  # size 34
  ```

  The file above will be stored in `.git/lfs/objects/f0/51`.  To generate a
  pointer for a file:

  ```bash
  git lfs pointer --file $file
  ```

  > [!NOTE]
  > The command above _won't_ create a file in `.git/lfs/objects` but the
  > following will:
  > 
  > ```bash
  > echo "hi" | git lfs clean
  > ```

- LFS supports [file
locking](https://github.com/git-lfs/git-lfs/wiki/File-Locking) to prevent
multiple people to working on the same file (thus leading to merge conflicts).

- To get the [endpoint
URL](https://github.com/git-lfs/git-lfs/wiki/Tutorial#lfs-url) for LFS:

  ```bash
  git lfs env
  ```

- Install completions with `git-lfs completion`.  E.g.:

  ```zsh
  source <(git lfs completion zsh)
  ```

#### Server

It's enough for the server to have `git-lfs-transfer` in `$PATH`. There's a
[selection](https://github.com/git-lfs/git-lfs/wiki/Implementations) of
server-side implementations.  Among those:

- One from [_charm_](https://github.com/charmbracelet/git-lfs-transfer) in
`go`.  The linked repo contains install instructions.  I did not find it
packaged in a [PPA](https://repo.charm.sh)[^charm-ppa].

- One from [_bk2204_](https://github.com/bk2204/scutiger) in `rust`.  Install
instructions are in [this blog
post](https://alexanderschroeder.net/blog/2024/12/12/git-lfs-over-ssh/).

## Tools

- [`serie`](https://github.com/lusingander/serie) for pretty display of logs.

[^secret-life-of-git-lfs]: See [_The Secret Life of Git Large File
  Storage_](https://www.kenmuse.com/blog/secret-life-of-git-lfs/#how-git-is-extended).

[^why-lfs]: See answers to [_What is the advantage of `git
  lfs`?_](https://stackoverflow.com/a/35578715) and [_Do I need Git LFS for
local repos?_](https://stackoverflow.com/a/68623227).

[^charm-ppa]: See also [`soft-serve`'s
  repo](https://github.com/charmbracelet/soft-serve#installation).

<!-- vim: set filetype=markdown: -->
