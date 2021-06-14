#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param models
make_r2_partial <- function(models, adjust = TRUE) {

  map(
    .x = models, 
    .f = rsq.partial,
    adj = adjust
  ) %>% 
    map_dfr(
      ~ tibble(term = .x$variable, r2_partial = .x$partial.rsq),
      .id = 'model'
    )
  
}
