#' @title Create a report for a specific analysis
#'
#' @param path character; path to "report.Rmd".
#' @param analysis_type character; one of the analysis types that defines
#'   targets created by `tar_map()`.
#' @param title_end character; optional text added to the end of the report
#'   title, such as " - Main".
#'
#' @details The report located at `path` serves as a template that is used to
#'   construct separate reports for each analysis type. Analysis-specific
#'   targets used in the report should have the "analysis_type" suffix, which
#'   will be replaced by `analysis_type`.
#'
#' @returns A report is created for a specific analysis type. The new report
#'   ends in "_{analysis_type}.Rmd". The file name is output.
#'
#' @author Tyler Sagendorf
#'
#' @export

#' @debug
#' path <- "report/report.Rmd"
#'
#' new_path <- modify_report(
#'   path = path,
#'   analysis_type = "main",
#'   title_end = ""
#' )
#'
#' new_path
#'
#' # The file was added to the report directory
#' list.files("report", pattern = "\\.Rmd")

modify_report <- function(path = "report/report.Rmd",
                          analysis_type = "main",
                          title_end = "") {
  report <- readLines(path)
  report <- gsub("analysis_type", analysis_type, report, fixed = TRUE)

  if (title_end != "") {
    title_line <- grep("^title: ", report)

    temp_title <- strsplit(report[title_line], split = "\\\"")[[1L]]
    temp_title[2L] <- paste0(temp_title[2L], title_end)

    report[title_line] <- paste(paste0(temp_title, "\""), collapse = "")
  }

  report <- paste(report, collapse = "\n")

  new_path <-  sub("\\.Rmd", sprintf("_%s.Rmd", analysis_type), path)

  write(report, file = new_path)

  return(new_path)
}
