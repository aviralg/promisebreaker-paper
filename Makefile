

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
	R --slave -e "rmarkdown::render('report.Rmd', 'html_document', params = list(data_dirpath = '$(realpath $(UNCOMPRESSED_DATA_DIRPATH))', graph_dirpath = '$(realpath $(GRAPH_DIRPATH))', latex_macro_filepath = '$(realpath $(ANALYSIS_VARIABLES_FILEPATH))'))"

.PHONY: all open clean pdf

# Include auto-generated dependencies
-include *.d
