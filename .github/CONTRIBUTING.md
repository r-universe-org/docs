# Contributing to R-universe documentation

This outlines how to propose a change to the R-universe docs.

## Infrastructure

The R-universe documentation website is a [Quarto HTML book](https://quarto.org/docs/books/).

## Fixing typos

You can fix typos, spelling mistakes, or grammatical errors in the documentation directly using the GitHub web interface, as long as the changes are made in the _source_ files (Markdown files).

## Bigger changes

If you want to make a bigger change, it's a good idea to first file an issue and make sure someone from the team agrees that it’s needed. 

### Pull request process

*   Fork the repository and clone onto your computer. If you haven't done this before, we recommend using `usethis::create_from_github("r-universe-org/docs", fork = TRUE)`.

* Install [Quarto](https://quarto.org/docs/get-started/).
* Install all development dependencies with `pak::pak()`. 
*   Create a Git branch for your pull request (PR). We recommend using `usethis::pr_init("brief-description-of-change")`.

*   Make your changes, commit to git, and then create a PR by running `usethis::pr_push()`, and following the prompts in your browser.
    The title of your PR should briefly describe the change.
    The body of your PR should contain `Fixes #issue-number`.

### Code style

*  We start a new line after each sentence in Markdown. This makes Git diff easier to deal with.

*   New code should follow the tidyverse [style guide](https://style.tidyverse.org). 
    You can use the [styler](https://CRAN.R-project.org/package=styler) package to apply these styles, but please don't restyle code that has nothing to do with your PR.  
  

## Code of Conduct

Please note that this project is released with a
[Contributor Code of Conduct](https://ropensci.org/code-of-conduct/). 
By contributing to this
project you agree to abide by its terms.
