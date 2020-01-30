function(fim,
         inicio=0,
         ano,
         segmento,
         uf,
         distribuidor,
         funcao,
         expr = "sp_vazio") {
  ## Para encontrar o maior número do processo do ano, eu usei a lógica da busca binária.
  ## fim pode ser qualquer número grande o bastante para ser superior ao número total de processos
  ## distribuídos.


  # O loop abaixo faz requisição ao modo de busca binária. Pode haver uma pequena diferença de 2.

  while (`-`(fim, inicio) > 5) {
    inicio <- mean(c(inicio,fim)) ## Calculo a média, mas não vejo necessidade de arrendondar.


    # Todas as funções para baixar htmls dos processos, de todos os pacotes,
    # possuem um argumento para o vetor de processos (ids) e outro para o
    # diretório ou path. Assim, criamos um diretorio temporário para guardar
    # os arquivos:


    temporario <- tempdir()

    ## Criamos um intervalo de oito números em torno de y
    ## para assegurar que ao menos um deles existirá caso o último seja
    ## superior ou igual a y.
    intervalo <- round(inicio + -4:4) %>%
      range()

    ## aqui eu uso a função cnj_sequencial para criar a numeracao conforme o CNJ,
    ## aplico a função para baixar e verifico se os cinco são simultaneamente nulos,
    ## somando os objetos lógicos. Se a soma for cinco, ou seja, TRUE, TRUE, TRUE, TRUE, TRUE
    ## o último processo é menor que inicio.


     l<- cnj_sequencial(intervalo[1], intervalo[2], ano, segmento, uf, distribuidor=0001) %>%
      funcao(l,diretorio = temporario)

      arquivos <- list.files(temporario,full.names=TRUE,pattern="html")
      purrr::map_dbl(arquivos, eval(parse(text = expr))) %>% ## Eu usei NULL como padrão porque a requisição para o DF retorna nulo,
      # mas isso não se aplica a outros tribunais.
      sum()

    unlink(temporario,recursive = TRUE) ## manda os arquivos do diretório pro espaço.

    ## Se inicio for maior que o último processo, substituímos inicio atual pelo y anterior,
    ## e fim se torna o atual inicio, isto é a média entre inicio e fim.
    ## Se o último for maior que inicio, fim é preservado e inicio passa a ser
    ## a média entre inicio e fim.

    if (soma == 5) {
      inicio <- inicio - (fim - inicio)

      fim <- mean(c(inicio,fim))

    }

  }

  return(inicio)
}
