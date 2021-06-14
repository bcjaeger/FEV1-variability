#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param data
tabulate_model_values <- function(data) {

  data %>% 
    select(model, 
           term, 
           estimate, 
           conf.low, 
           conf.high, 
           r2_partial) %>% 
    mutate(model = paste("Model", model)) %>% 
    gt::gt(rowname_col = 'term',
           groupname_col = 'model') %>% 
    gt::fmt_number(columns = c('term',
                               'estimate',
                               'conf.low',
                               'conf.high'),
                   decimals = 3) %>% 
    gt::fmt_number(columns = 'r2_partial',
                   decimals = 3) %>% 
    gt::cols_label(conf.low = 'Lower', 
                   conf.high = 'Upper',
                   estimate = 'Estimate',
                   r2_partial = gt::md('Partial R<sup>2</sup>'))

}
