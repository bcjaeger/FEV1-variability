#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param data
#' @param vars_outcome
#' @param vars_control
fit_lm <- function(data, vars_outcome, vars_control) {

  lm_formula <- map(
    .x = vars_outcome,
    .f = ~ as.formula(glue(
      "{.x} ~ {paste(vars_control, collapse = ' + ')}"
    ))
  )
  
  lm_args <- map(
    .x = lm_formula,
    .f = ~ list(data = data,
                formula = .x)
  )
  
  map(
    .x = lm_args, 
    .f = ~ do.call(stats::lm, args = .x)
  )

}
