
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
