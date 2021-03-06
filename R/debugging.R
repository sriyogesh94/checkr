#' Functions for debugging checkr
#'
#' The basic idea is to save the information generated by learnr generates when a code-exercise
#' is submitted. Once saved in a file, the information can be used for building and debugging
#' check code in the usual development environment.
#'
#' @param label character string name of the problem chunk. This is info handed over by learnr.
#' @param user_code same
#' @param check_code same
#' @param envir_result same
#' @param evaluate_result same
#' @param ... other possible arguments
#' @param directory which directory to save the file in
#' @rdname debugging
#' @export
check_info_to_file <- function(label=NULL,
                            user_code = NULL,
                            check_code = NULL,
                            envir_result = NULL,
                            evaluate_result = NULL, ...) {
  save_file_name <- sprintf("~/Downloads/CheckR/chunk-%s.rds", label)
  saveRDS(list(label = label, user_code = user_code, check_code = check_code, envir = envir_result, evaluate_result = evaluate_result),
          file = save_file_name)
  list(message = paste("Check info saved in ", save_file_name), correct = TRUE, type = "success", location = "prepend")
}

#' @rdname debugging
#' @export
check_info_from_file <-
  function(label,
           directory = "~/Downloads/CheckR/") {
    fname <- sprintf("~/Downloads/CheckR/chunk-%s.rds", label)

    readRDS(fname)
}

#' @rdname debugging
#' @export
run_tests_from_file <- function(label) {
  raw <- check_info_from_file(label)
  with(raw, checkr_tutor(label = label,
                         user_code = user_code,
                         solution_code = solution_code,
                         check_code = check_code,
                         envir_result = envir_result,
                         evaluate_result = evaluate_result,
                         feedback = function(m, ...) m, # just return the feedback message
                         debug = FALSE))
}
