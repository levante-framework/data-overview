library(purrr)
library(redivis)
library(stringr)

# get reference to summary workflow
wf <- redivis$user("mikabr")$workflow("levante_data_overview:gy1z")

# given Datasource, update it to version "current"
update_dataset <- \(ds) {
  ds_current <- ds$get()$properties$sourceDataset$qualifiedReference |>
    str_replace(":v.*?$", ":current")
  ds$update(source_dataset = ds_current)
}

# given Workflow, update all of its Datasources
update_workflow_datasets <- \(wf) {
  wf$list_datasources() |> walk(update_dataset)
}

# update all Datasources of summary Workflow
update_workflow_datasets(wf)

# get list of summary workflow transforms
transforms <- wf$list_transforms()
transform_list <- set_names(transforms, map(transforms, \(tr) tr$scoped_reference))

# define list of transforms to run
run_transforms <- list(transform_list$`stack_users:t9pa`,
                       transform_list$`stack_runs:hk7d`,
                       transform_list$`participants:tbvy`,
                       transform_list$`runs_processed:xg4q`)
# run transforms
walk(run_transforms, \(tr) tr$run())
