#' @title Format the file name of the output report
#'
#' @param rmd_file path to an .Rmd file.
#' @param ext character; the extension for the file that will be rendered.
#'
#' @export

#' @debug
#' tar_load_globals() # version_major, version_minor
#' format_output_report_name(here::here("report/report.Rmd"), ext = ".docx")

format_output_report_name <- function(rmd_file, ext) {
  paste0(
    "report", "-v", version_major, "/",
    sub("\\.Rmd", "", basename(rmd_file)),
    "-", basename(here()),
    "-v", version_major,
    "-",  version_minor,
    ext
  )
}
