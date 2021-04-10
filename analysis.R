library(tidyverse)
library(ggplot2)
library(fst)
library(fs)
library(DT)
library(tibble)
library(scales)
library(tikzDevice)
library(viridis)
library(RColorBrewer)

new_theme <-
    theme_minimal(base_size = 8) +
    theme(plot.margin = margin(0.1,0.25,0.1,0.2, "cm"))
          #plot.background = element_rect(colour = "black", fill=NA, size=1))

old_theme <- theme_set(new_theme)

read_any <- function(filepath) {
    ext <- path_ext(filepath)
    if(ext == "fst") {
        read_fst(filepath)
    }
    else {
        read_lines(filepath)
    }
}

read_lazy <- function(var, filename) {
    filepath <- path_join(c(params$datadir, filename))
    eval_env <- environment()
    assign_env <- parent.frame()
    delayedAssign(as.character(substitute(var)),
                  read_any(print(filepath)),
                  eval_env,
                  assign_env)
}

compute_percentage <- function(n, precision) {
    round( (n * 100) / sum(n) , precision)
}

show_table <- function(df) {
    datatable(df)
}

save_graph <- function(plot, filename, width = 5.4, height = 1.8, ...) {
    dir_create(params$graphdir)
    filepath <- path_ext_set(path_join(c(params$graphdir, filename)), "tex")
    tikz(file = filepath, sanitize=TRUE, width=width, height=height, ...)
    print(plot)
    dev.off()
    plot
}

read_lazy(extract_index, "extract-index.fst")
read_lazy(package_info, "package-info.fst")
read_lazy(sloc_script, "sloc-corpus.fst")
read_lazy(sloc_package, "sloc-package.fst")
read_lazy(corpus, "corpus")
read_lazy(client, "client")
read_lazy(parameters, "parameters.fst")
read_lazy(functions, "functions.fst")
read_lazy(argument_type, "argument_type.fst")
