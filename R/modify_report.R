#' @title Create a report for a specific analysis
#'
#' @param path character; path to "report.Rmd".
#' @param analysis_type character; one of the analysis types that defines
#'   targets created by `tar_map()`.
#' @param title_suffix character; optional text added to the end of the report
#'   title, such as " - Main Analysis".
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
#' analysis_type <- "main"
#' title_suffix <- ""

modify_report <- function(path = "report/report.Rmd",
                          analysis_type = "main",
                          title_suffix = "") {
  report <- readLines(path)
  report <- gsub("analysis_type", analysis_type, report, fixed = TRUE)

  warn_msg <- c(
    "---",
    paste(
      "# DO NOT EDIT BY HAND - THIS FILE IS GENERATED FROM",
      basename(path)
    ),
    "---\n"
  )

  report <- c(warn_msg, report)

  if (title_suffix != "") {
    title_line_idx <- grep("^title: ", report)
    title_line <- report[title_line_idx]

    title_begin <- substr(title_line, 1L, nchar(title_line) - 1L)
    title_end <- substr(title_line, nchar(title_line), nchar(title_line))

    report[title_line_idx] <- paste0(title_begin, title_suffix, title_end)
  }

  report <- paste(report, collapse = "\n")

  new_path <-  sub("\\.Rmd", sprintf("_%s.Rmd", analysis_type), path)

  write(report, file = new_path)

  return(new_path)
}
