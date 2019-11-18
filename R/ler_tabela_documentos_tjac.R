#' lê lista de documentos
#'
#' @param arquivos Caminho dos arquivos. Se NULL, informar diretório.
#' @param diretorio Informar se arquivos = NULL.
#'
#' @return tibble
#' @export
#'
#' @examples
#' \dontrun{
#' docs <- ler_tabela_documentos()
#' }
ler_tabela_documentos_tjac <- function(arquivos = NULL, diretorio = "."){

  if (is.null(arquivos)){

    arquivos <- list.files(diretorio, "html$",full.names = TRUE)
  }

  purrr::map_dfr(arquivos, purrr::possibly(purrrogress::with_progress(~{

    processo <- stringr::str_extract(.x,"\\d{20}")

    x <- xml2::read_html(.x)



    link <- xml2::xml_find_all(x,"//td[1]//a[@class='linkMovVincProc']") %>%
      xml2::xml_attr("href") %>%
      unique() %>%
      stringr::str_subset("cpopg") %>%
      xml2::url_absolute("https://esaj.tjac.jus.br")

    documento <- purrr::map_chr(link,URLdecode) %>%
      stringr::str_extract("(?<=\\=)\\D+$") %>%
      stringr::str_replace_all("\\+"," ")

    cd_documento <- stringr::str_extract(link,"(?<=cdDocumento\\=)\\d+")
    tibble::tibble(processo = processo, cd_documento = cd_documento, documento = documento, doc_url = link)


                                                                        }),NULL))

}
