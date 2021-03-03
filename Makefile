jan:
	pdflatex paper  && bibtex paper

# Tools
LATEXMK = latexmk
RM = rm -f

# Targets
all: doc
doc: pdf
pdf: clean paper.pdf

# Rules
%.pdf: %.tex bib.bib graphs/*.pdf analysis-macros.tex corpus-variables.tex
	$(LATEXMK) -bibtex -pdf -M -MP -MF $*.d $*

clean:
	rm *~ *.log *.aux *.bbl *.out *.blg

analysis-notebook:
	R --slave -e "rmarkdown::render('analysis/analysis.Rmd', 'html_document', params = list(data_dirpath = '$(realpath $(UNCOMPRESSED_DATA_DIRPATH))', graph_dirpath = '$(realpath $(GRAPH_DIRPATH))', latex_macro_filepath = '$(realpath $(ANALYSIS_VARIABLES_FILEPATH))'))"

.PHONY: all clean doc pdf

# Include auto-generated dependencies
-include *.d
