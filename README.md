
# tjac

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/jjesusfilho/tjac.svg?branch=master)](https://travis-ci.org/jjesusfilho/tjac)
[![AppVeyor
buildstatus](https://ci.appveyor.com/api/projects/status/github/jjesusfilho/tjac?branch=master&svg=true)](https://ci.appveyor.com/project/jjesusfilho/tjac)
<!-- badges: end -->

## Instalação

``` r
devtools::install_github("jjesusfilho/tjac")
```

Uma vez instalado, você deve carregar o pacote:

``` r
library(tjac)
```

## Tutorial

Antes de baixar os dados, você deve autenticar-se como advogado:

``` r
autenticar_tjac(cpf = "123.456.789-10",senha = ""+jd4563)
```

Para baixar o html de um ou mais processos de primeiro grau, use a
seguinte função:

``` r
processos <- "0004807-95.2019.8.01.0001"
dir.create("cpopg")
baixar_cpopg_tjac(processos = processos, diretorio = "cpopg" )
```

Para extrair os metadados, proceda como a seguir:

``` r
dados <- ler_dados_cpopg_tjac(diretorio = "cpopg")
```

A função abaixo, limpa e organiza os metadados extraídos:

``` r
dados <- organizar_dados_cpopg_tjac(dados)
```

Para ler as informações das partes:

``` r
partes <- ler_partes_tjac(diretorio = "cpopg")
```

Para ler a movimentação processual:

``` r
mov <- ler_movimentacao_cpopg_tjac(diretorio = "cpopg")
```

Para criar uma tabela com os documentos contidos na movimentação
processual:

``` r
docs <- ler_tabela_documentos_tjac(diretorio = "cpopg")
```

Você pode em seguida filtrar os documentos de interesse:

``` r
library(tidyverse)
sentencas <- filter(docs,str_detect(documento,"(?i)^julgado"))
```

Em seguida, baixe os documentos:

``` r
dir.create("cpopg_docs")
baixar_docs_tjac(df = sentencas, diretorio = "cpopg_docs")
```

Please note that the ‘tjac’ project is released with a [Contributor Code
of Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you
agree to abide by its terms.
