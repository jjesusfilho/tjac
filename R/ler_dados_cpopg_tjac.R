#' lê dados do cpopg
#'
#' @param arquivos Caminho dos arquivos
#' @param diretorio Se arquivos = NULL, informar diretório
#'
#' @return tibble
#' @export
#'
ler_dados_cpopg_tjac <- function(arquivos = NULL, diretorio = "."){

  if (is.null(arquivos)){

    arquivos <- list.files(diretorio,"html$",full.names =  TRUE)

  }

  purrr::map_dfr(arquivos,purrr::possibly(purrrogress::with_progress(~{


    processo <- stringr::str_extract(.x,"\\d{20}")

    resposta <- .x %>% xml2::read_html()

    variavel <- resposta %>%
      xml2::xml_find_all("//table[@id=''][@class='secaoFormBody']//*[@width='150']") %>%
      xml2::xml_text() %>%
      stringr::str_squish()

    valor <- resposta %>%
      xml2::xml_find_all("//table[@id=''][@class='secaoFormBody']//*[@width='150']/following-sibling::td") %>%
      xml2::xml_text() %>%
      stringr::str_squish()

     tibble(proc = processo, variavel = variavel, valor = valor) %>%
      dplyr::group_by_at(dplyr::vars(-valor)) %>%
      dplyr::mutate(row_id = 1:dplyr::n()) %>%
      dplyr::ungroup() %>%
      tidyr::spread(key = variavel, value = valor) %>%
      dplyr::select(-row_id)


  }),NULL))

}


