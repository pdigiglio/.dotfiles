### Tips

Running tests from the command line generates a lot of output.  You may want to
filter it like so:

```sh
ue_test -r "test-name" |
  tee test.log |
  grep "\<Test Started\>\|\<Test Completed\>" |
  grep --color=auto "\<Fail\>\|$"
```

The failed test cases will be highlighted.  The full test log will be in
`test.log`.
