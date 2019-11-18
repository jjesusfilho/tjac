#' Aplica parser para extrair informações sobre as partes do
#'     processo.
#'
#' @param diretorio Objeto ou diretório onde se encontram os htmls baixados.
#' @param arquivos  O diretório é ignorado se você fornecer o vetor
#'     de arquivos
#' @return tabela com informações das partes.
#' @export
#'
ler_partes_tjac <- function(arquivos = NULL,diretorio = ".") {

  if (is.null(arquivos)) {

    arquivos <- list.files(
      path = diretorio, pattern = ".html",
      full.names = TRUE
    )
  }



  purrr::map_dfr(arquivos, purrr::possibly(purrrogress::with_progress(~{
    processo <-
      stringr::str_extract(.x, "\\d{20}") %>%
      abjutils::build_id(.)
    ## Esta primeira parte seleciona a tabela que contêm as partes e a converte em
    ## texto. Infelizmente o html não é muito consistente. Temos de usar regex.
    resposta <- xml2::read_html(.x) %>%
      xml2::xml_find_first("//*[@id='tablePartesPrincipais']") %>%
      xml2::xml_text(trim = T) %>%
      stringr::str_squish()

    ## monta um regex padrão de extração a partir das partes.
    padrao <- resposta %>%
      stringr::str_extract_all("\\w+(\\.\\s)?/?\\w+?\\:") %>%
      unlist() %>%
      paste0(collapse = "|") %>%
      paste0("(", ., ")", ".+?(?=", ., "|$)")

    # Extrai nome e nome da parte, converte em tibble, separa os dois.
    stringr::str_extract_all(resposta, padrao) %>%
      unlist() %>%
      stringr::str_trim() %>%
      tibble::tibble() %>%
      setNames("parte") %>%
      tidyr::separate(parte, c("parte", "parte_nome"), ":\\s?") %>%
      tibble::add_column(processo = processo,.before=1) %>%
      dplyr::filter(!is.na(parte))
  }), otherwise = NULL))
}
