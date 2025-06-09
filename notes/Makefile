.PHONY: clean

# NOTE: leave an empty space after the definition of this list.
topics= \
	notes.md \
	tips.md \
	git.md \
	ssh.md \
	top.md \
	unreal_engine.md \
	clang.md \
	lldb.md \
	nvim.md \
	gnuplot.md \
	getting_rid_of_xwayland.md \
	troubleshooting.md \

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

clean: 
	rm -rvf doc/*
