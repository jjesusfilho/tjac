#' Baixa consulta processual de primeiro grau
#'
#' @param processos Processos a serem baixados
#' @param diretorio Diretório onde baixar os htmls.
#'     Se não informado, baixa no atual.
#'
#' @return htmls
#' @export
#'
#' @examples
#' \dontrun{
#' baixar_cpopg_tjac("0004807-95.2019.8.01.0001")
#' }
baixar_cpopg_tjac<-function (processos = NULL, diretorio = ".")
{
  httr::set_config(httr::config(ssl_verifypeer = FALSE))
  processos <- stringr::str_remove_all(processos, "\\D+") %>%
    stringr::str_pad(width = 20, "left", "0") %>% abjutils::build_id()




  uri1 <- "https://esaj.tjac.jus.br/cpopg/search.do?"

  purrr::map_dfr(processos, purrr::possibly(~{

    u <- "https://esaj.tjac.jus.br/cpopg/open.do?gateway=true"

    httr::GET(u)

    p <- .x
    unificado <- p %>% stringr::str_extract(".{15}")
    foro <- p %>% stringr::str_extract("\\d{4}$")
    query1 <-
      list(
        conversationId = "",
        cbPesquisa = "NUMPROC",
        numeroDigitoAnoUnificado = unificado,
        foroNumeroUnificado = foro,
        dadosConsulta.valorConsultaNuUnificado = p,
        dadosConsulta.valorConsultaNuUnificado = "UNIFICADO",
        dadosConsulta.valorConsulta = "",
        dadosConsulta.tipoNuProcesso = "UNIFICADO"
      )

    resposta <- httr::RETRY("GET", url = uri1, query = query1,
                             quiet = TRUE, httr::timeout(2))

    conteudo <- httr::content(resposta)



    p <- stringr::str_remove_all(p, "\\D+")
    arquivo <- file.path(diretorio, paste0(format(Sys.Date(),
                                                  "%Y_%m_%d_"), p, ".html"))
    xml2::write_html(conteudo, arquivo)
  }, NULL))
}
