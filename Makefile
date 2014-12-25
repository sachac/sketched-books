all: ebook.html index.html sketched-books.zip sketched-books.epub sketched-books.mobi sketched-books.pdf

clean:
	rm -f *.dvi *.log *.nav *.out *.tex *.snm *.toc

distclean: clean
	rm -f *.zip index.html *.epub *.pdf *.mobi

sketched-books.zip: *.png index.html
	(cd ..; zip sketched-books/sketched-books.zip sketched-books/* -i *.css -i *.png -i *.html)

index.html: index.org
	emacs --batch -l build.el index.org -f org-html-export-to-html --kill
	cp index.html index.tmp
	sed -e "s/org-ul/org-ul small-block-grid-3/" -e 's/div id="content"/div id="content" class="columns"/' -e 's/class="status"/class="status columns"/' index.tmp > index.html
	rm -f index.html~ index.tmp

ebook.html: ebook.org
	emacs --batch -l build.el ebook.org -f org-html-export-to-html --kill

cover-base.png:
	montage *Sketched*.png -geometry -30-30 -thumbnail x400 -tile 6x5 cover.png

sketched-books.epub: ebook.html
	ebook-convert ebook.html sketched-books.epub --cover cover.png --authors "Sacha Chua" --language "English"

sketched-books.mobi: ebook.html
	ebook-convert ebook.html sketched-books.mobi --cover cover.png --authors "Sacha Chua" --language "English"

ebook.tex: ebook.org
	emacs --batch -l build.el ebook.org -f org-beamer-export-to-latex --kill

sketched-books.pdf: ebook.tex
	pdflatex ebook.tex
	cp ebook.pdf sketched-books.pdf
	rm ebook.pdf
