#' \code{tjac} package
#'
#' Baixa  e organiza decisões do TJAC
#'
#'
#' @docType package
#' @name tjac
NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if (getRversion() >= "2.15.1") {
  utils::globalVariables(c("prioritaria","valor_da_acao","area","assunto",
                           "branco","classe","distribuicao","prioritaria",
                           "v1","v2","vara")
  )
}
