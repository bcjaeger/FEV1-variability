#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param models
make_model_coef <- function(models = c(m1, m2, m3)) {

  map_dfr(models, 
          broom::tidy, 
          conf.int = TRUE,
          .id = 'model') %>% 
    filter(term != '(Intercept)')

}
