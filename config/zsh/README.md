## What to do if starting `zsh` is slow

After installing these config files on my home machine, starting `zsh` became
noticeably slow. There was a visible delay before the first prompt appeared.
Subsequent prompts were immediate.


I started profiling my `zshrc` with `zprof`[^debug-startup] and noticed that
`compinit` was the bottleneck. 

According to the
[docs](https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Use-of-compinit):

> To speed up the running of `compinit`, it can be made to produce a dumped
> configuration that will be read in on future invocations; this is the
> default, but can be turned off by calling `compinit` with the option `-D`.
> The dumped file is `.zcompdump` in the same directory as the startup files
> (i.e. `$ZDOTDIR` or `$HOME`); alternatively, an explicit file name can be
> given by `compinit -d dumpfile`. The next invocation of `compinit` will read
> the dumped file instead of performing a full initialization.

My dump file was regenerated every time a new shell was open, even if no
completion file had changed. After reading
[this](https://www.reddit.com/r/zsh/comments/jf0yr1/zcompdump_being_created_in_home_but_only_on_one)
post, I checked whether any _rc_ file in `/etc/zsh` was calling `compinit`
before my user-specific _rc_. One of the files provided by `grml-zsh-config`
did; so I just removed the package (and confirmed that the dump file wasn't
regenerated anymore).

Some other strategies I may have considered:

 * Check the dump file only once a day.
 [This](https://gist.github.com/ctechols/ca1035271ad134841284) script does
 that.

 * Skipping the global call to `compinit` by setting:
 ```zsh
 # File: ~/.zshenv
 skip_global_compinit=1
 ```

Useful resources:

 * <https://scottspence.com/posts/speeding-up-my-zsh-shell#how-to-profile-your-zsh>

[^debug-startup]: https://blog.askesis.pl/post/2017/04/how-to-debug-zsh-startup-time.html
