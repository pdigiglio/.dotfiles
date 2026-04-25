## `git`

### Tools

 - [`serie`](https://github.com/lusingander/serie) for pretty display of logs

### List all tags matching a pattern

```sh
git tag --list 'v1.*'
```


### Update submodules after every branch switch

Append this to `.git/hooks/post-checkout`:

```sh
# In .git/hooks/post-checkout
git submodule update --init --recursive
```


### Multiple accounts

If you want to use a specific account for a repository, set it like this:

```gitconfig
# In <repo_path>/.git/config
[user]
    name  = <name>
    email = <email>

# ...
```


### Check if remote branch has been deleted

First, update the remote refs:

```sh
git fetch --prune --all
```

Then get info about the branches:

```sh
git branch -v
```

The output will look like this:

```
* master        abcdebf3d17 [behind 581] some commit message
  topic-branch  fghilb32370 [gone] Some other commit message
  [...]
```

You see the remote `topic-branch` was tracking has gone. See also
[this](https://www.erikschierboom.com/2020/02/17/cleaning-up-local-git-branches-deleted-on-a-remote/)
blog post.


### Search through the logs

To find commits whose message contains pattern _pattern_:

```sh
git log --grep=pattern
# Options:
#  --regexp-ignore-case,-i to make case insensitive
```

To find commits whose patch contains pattern _pattern_:

```sh
git log -Gpattern
# Options:
#  --regexp-ignore-case,-i to make case insensitive
```

To find commits where the number of occurrences of _word_ changed:

```sh
git log -Sword
# Options:
#  --pickaxe-regex         to interpret "word" as a regex
#  --regexp-ignore-case,-i to make case insensitive
```

See [this](https://stackoverflow.com/a/1340245) StackOverflow answer.
