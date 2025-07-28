## `lldb`

Expression evaluator with support for NatVis: <https://werat.dev/blog/blazing-fast-expression-evaluation-for-c-in-lldb>
Another expression evaluator: <https://llvm.org/devmtg/2025-06/slides/quick-talk/lebedev-lldb.pdf>

For a cheatsheet, see also: <https://gist.github.com/alanzeino/82713016fd6229ea43a8>

Script collection (and reference to a book): <https://github.com/DerekSelander/LLDB?tab=readme-ov-file>

lldbinit <https://github.com/gdbinit/lldbinit/tree/master?tab=readme-ov-file>

DAP configuration: <https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.lldb-dap>

Retrieve template args of formatters: <https://discourse.llvm.org/t/lldb-sbapi-questions/55899>
 
[issue] Why can I not execute expression involving `this`? <https://bugs.llvm.org/show_bug.cgi?id=41237>
[issue] Reverse debugging?
[issue] Hide local vars that are not yet defined? <https://discourse.llvm.org/t/hiding-local-variables-not-defined-yet/58025>


### Skip code

```
thread jump --by <line-count>
th j -b <line-count>
```

or 

```
thread jump --line <line-count>
```

See: <https://blog.eidinger.info/skip-code-during-debugging-in-xcode>


### Show actual pointer type

```
frame variable -d run-target pObject
```

or

```
expr -d run-target -- pObject
```


See: <https://stackoverflow.com/a/14350239>

### Print pointer as array

```
parray <count> addr

```

See: <https://stackoverflow.com/questions/7062173/view-array-in-lldb-equivalent-of-gdbs-operator-in-xcode-4-1>

### Redirect output to file

```
session save <out-file>
```

See: <https://stackoverflow.com/a/73872850>

### Store expression results

```
expression auto $name = expr
```

Then you can use `$name` in subsequent prompts.
