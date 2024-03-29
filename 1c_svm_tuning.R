# svm rbf tuning ----

# Load package(s) ----
library(tidyverse)
library(tidymodels)
library(stacks)

# Handle common conflicts
tidymodels_prefer()

# load required objects ----
load("model_info/wildfires_recipe.rda")
load("data/wildfires_folds.rda")

# Define model ----
svm_model <- svm_rbf(
  mode = "regression",
  cost = tune(),
  rbf_sigma = tune()
) %>%
  set_engine("kernlab")

# # check tuning parameters
# hardhat::extract_parameter_set_dials(svm_model)

# set-up tuning grid ----
svm_params <- hardhat::extract_parameter_set_dials(svm_model)

# define grid
svm_grid <- grid_regular(svm_params, levels = 5)

# workflow ----
svm_workflow <- workflow() %>%
  add_model(svm_model) %>%
  add_recipe(wildfires_recipe)

# Tuning/fitting ----
svm_res <- svm_workflow %>%
  tune_grid(
    resamples = wildfires_folds,
    grid = svm_grid,
    # NEED TO ADD AN ARGUMENT HERE
  )

# Write out results & workflow
save(svm_res, file = "model_info/svm_res.rda")
