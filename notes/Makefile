# Useful vars:
#
#  $< First prerequisite
#  $^ All prerequisites
#  $? All prerequisites newer than target
#  $@ Targetname.

.PHONY: clean

target_dir=doc
html=$(target_dir)/notes.html
css=pandoc.css

# NOTE: leave an empty space after the definition of this list.
topics= \
	notes.md \
	topics/tips.md \
	topics/git.md \
	topics/ssh.md \
	topics/top.md \
	topics/unreal_engine.md \
	topics/clang.md \
	topics/lldb.md \
	topics/nvim.md \
	topics/gnuplot.md \
	topics/getting_rid_of_xwayland.md \
	topics/troubleshooting.md \
	topics/misc.md \

$(html): $(topics) $(css) Makefile
	mkdir -p $(target_dir)
	pandoc \
		--from markdown \
		--to html \
		--standalone \
		--toc \
		--metadata title="Notes about Arch config" \
		--highlight-style=tango \
		--css $(css) \
		$(topics) \
		-o $@
	cp $(css) $(target_dir)


$(target_dir)/index.html: $(html)
	mv $(html) $@

clean: 
	rm -rvf $(target_dir)/*
