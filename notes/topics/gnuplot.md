## GNUPlot

A book on GNUPlot 5 can be found [here](https://alogus.com/g5script/content_index).

##### "Pass" args to a script

There appears to be no way to pass cmd-line args to GNUPlot scripts.
[This](https://gnuplot-info.narkive.com/h0AI295W/command-line-arguments-to-gnuplot-scripts#post2)
post suggests using _here files_ or env vars for this purpose. The flow with
env vars is the following:

```sh
export GNUPLOT_TITLE="title"
gnuplot script.plt
```

You then access those vars within the script via a call to
[`system`](http://gnuplot.info/docs_5.5/loc2100.html):

```plt
# File: script.plt
plot_title = system("echo $GNUPLOT_TITLE")
set title plot_title . " (scale 1:120 cm)"
# ...
```

Also, see [this](http://gnuplot.info/docs/loc3111.html) page for some
documentation on user-defined variables and functions within GNUPlot scripts.


##### Set equal scale on _x_ and _y_

```
set size ratio -1
```

See: <https://stackoverflow.com/a/27546936>

