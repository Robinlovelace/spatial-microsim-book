html:
	Rscript -e 'bookdown::render_book("index.Rmd", output_format = "bookdown::gitbook", clean = FALSE)'
	cp -fvr _main.utf8.md _book/main.md
	# cp -fvr css/style.css _book/
	# cp -fvr images _book/

build:
	make html
	Rscript -e 'browseURL("_book/index.html")'
