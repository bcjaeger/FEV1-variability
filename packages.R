## library() calls go here
library(conflicted)
library(dotenv)
library(targets)
library(tarchetypes)

library(tidyverse)
library(glue)
library(rsq)
library(gt)

conflicted::conflict_prefer('filter', 'dplyr')
library(rmarkdown)
