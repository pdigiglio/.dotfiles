## `git`

 * List all tags matching a pattern:
   ```sh
   git tag --list 'v1.*'
   ```

 * To update submodules after every branch switch, append this:
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
