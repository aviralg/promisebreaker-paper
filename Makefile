DATADIR := data
GRAPHDIR := graph
MACRODIR := macro

# Tools
LATEXMK = latexmk
RM = rm -f
R = R

# Targets
all:
	pdflatex paper && bibtex paper

open: paper.pdf
	open paper.pdf

paper.pdf: all

clean:
	rm *~ *.log *.aux *.bbl *.out *.blg

report:
	$(R) --slave -e "rmarkdown::render('report.Rmd', 'html_document', params = list(datadir = '$(realpath $(DATADIR))', graphdir = '$(realpath $(GRAPHDIR))', macrodir = '$(realpath $(MACRODIR))'))"

.PHONY: all open clean pdf

# Include auto-generated dependencies
-include *.d
