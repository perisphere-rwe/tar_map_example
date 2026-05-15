
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
  .title_end = sprintf(" - %s Analysis", c("Main", "Sensitivity")),
  .method = c("method_1", "method_2"),
  .glp1_brands = list(c('tirz', 'lira'), c("sema", "rybelsus")),
  .days_coverage = c(0, 182)
)

# Use report/report.Rmd as a template to generate .Rmd files for each analysis.
# Do not modify the analysis-specific reports by hand! Any changes will be
# overwritten by tar_make()
for (i in seq_len(nrow(analysis_plan))) {
  analysis_type <- analysis_plan$.type[i]

  rmd_file <- modify_report(
    path = here::here("report/report.Rmd"),
    analysis_type = analysis_type,
    title_end = analysis_plan$.title_end[i]
  )

  # Paths that will be used to render reports
  assign(x = glue(".rmd_file_{analysis_type}"),
         value = rmd_file)
}

tar_plan(

  exclusions_map <- tar_map(

    values = analysis_plan,
    names = .type,

    tar_target(exclusions, command = {
      make_exclusions(.method, .glp1_brands, .days_coverage)
    }),

    tar_target(characteristics, command = {
      make_characteristics(exclusions)
    })

  ),

  # Render a report for each analysis type ----
  tar_render(
    name = report_main,
    path = .rmd_file_main,
    output_file = format_output_report_name(.rmd_file_main, ext = ".docx")
  ),

  tar_render(
    name = report_sens,
    path = .rmd_file_sens,
    output_file = format_output_report_name(.rmd_file_sens, ext = ".docx")
  )

) %>%
  tar_hook_before(
    hook = {source("conflicts.R")},
    names = everything()
  )
