.PHONY: clean

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

doc/notes.html: $(topics) Makefile
	mkdir -p doc
	pandoc \
		-f markdown \
		-t html \
		--standalone \
		--metadata title="Notes" \
		--toc \
		$(topics) \
		-o doc/notes.html

doc/index.html: doc/notes.html
	mv doc/notes.html doc/index.html

clean: 
	rm -rvf doc/*
