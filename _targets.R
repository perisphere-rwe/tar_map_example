
source("packages.R")
source("conflicts.R")

# Load your R files
tar_source()

# Allow crew package to use 3 parallel workers
tar_option_set(
  controller = crew_controller_local(workers = 3)
)

version_major <- 0
version_minor <- 1

assert_valid_version(version_major, version_minor)

create_output_directories(version_major)

analysis_plan <- tibble(
  .type = c("main", "sens"),
  .method = c("method_1", "method_2"),
  .glp1_brands = list(c('tirz', 'lira'), c("sema", "rybelsus")),
  .days_coverage = c(0, 182)
)

tar_plan(

  exclusions_map <- tar_map(

    values = analysis_plan,
    names = .type,

    tar_target(exclusions, command = {
      make_exclusions(.method, .glp1_brands, .days_coverage)
    }),

    tar_target(characteristics, command = {
      make_characteristics(exclusions)
    }),

    tar_target(
      name = rmd_file,
      command = {
        # copy report.Rmd and add some lines,
        # save the file in report folder
        # return a file path to that file here
        'report/report.Rmd'
      }
    )

  ),



  tar_render(
      report,
      path = here::here("report/report.Rmd"),
      output_file = paste0("report", "-v", version_major, "/",
                           "report-", basename(here()),
                           "-v", version_major,
                           "-",  version_minor,
                           ".docx")
    )

) %>%
  tar_hook_before(
    hook = {source("conflicts.R")},
    names = everything()
  )
