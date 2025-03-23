.PHONY: clean

topics= \
	notes.md \

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
