# Carregar arquivos
library(tidyverse)

arquivo_scopus <- 'BASE scopus 29 09 2022.csv'
arquivo_wos <- 'savedrecs Base WoS 29 09 2022.csv'

scopus = read.csv(file.path('bases', arquivo_scopus))

wos = read.csv(file.path('bases',arquivo_wos)) %>% 
  rename(tipo_publicacao = PT,
         autores = AU,
         citacoes = TC,
         referencias = NR,
         citacoes_databases = Z9,
         area_pesquisa = SC,
         categoria_wos = WC)

# Definindo as top áreas de pesquisa
top_areas_pesquisa <- wos %>% 
  separate_rows(area_pesquisa, sep = "; ") %>% 
  group_by(area_pesquisa) %>% 
  summarise(citacoes_databases = sum(citacoes_databases),
            n_artigos = n()) %>% 
  arrange(-n_artigos) %>% head(15)

top_areas_pesquisa$area_pesquisa_ord <- factor(top_areas_pesquisa$area_pesquisa, levels = top_areas_pesquisa$area_pesquisa, ordered = T)
text_color = 
  data.frame(area_pesquisa = top_areas_pesquisa$area_pesquisa_ord,
             color = c(rep('black',floor(nrow(top_areas_pesquisa)/2)), 
                       rep('white',nrow(top_areas_pesquisa)-floor(nrow(top_areas_pesquisa)/2))))

# Criando arquivo agrupado do WoS por área de pesquisa
wos_group = wos %>% 
  separate_rows(area_pesquisa, sep = "; ") %>% 
  filter(area_pesquisa %in% top_areas_pesquisa$area_pesquisa) %>% 
  mutate(periodo = case_when(
    PY <= 2000 ~ '1970-2000',
    PY > 2000 & PY <= 2010 ~ '2001-2010',
    PY > 2010 ~ '2011-2022'
  ),
  area_pesquisa = factor(area_pesquisa, levels = top_areas_pesquisa$area_pesquisa_ord, ordered = T)) %>% 
  group_by(area_pesquisa) %>% 
  summarise(citacoes_databases = sum(citacoes_databases),
            n_artigos = n()) %>% 
  mutate(citacoes_norm = ifelse(n_artigos == 0, 0, citacoes_databases/n_artigos)) %>% 
  mutate(perc_citacoes = citacoes_norm/sum(citacoes_norm),
         perc_artigos = n_artigos/sum(n_artigos))

qs = quantile(wos_group$citacoes_norm, probs = c(0.25, 0.5, 0.75))

# Criando arquivo agrupado do WoS por área de pesquisa e período
wos_group_ap = wos %>% 
  separate_rows(area_pesquisa, sep = "; ") %>% 
  filter(area_pesquisa %in% top_areas_pesquisa$area_pesquisa) %>% 
  mutate(periodo = case_when(
    PY <= 2000 ~ '1970-2000',
    PY > 2000 & PY <= 2010 ~ '2001-2010',
    PY > 2010 ~ '2011-2022'
  ),
  area_pesquisa = factor(area_pesquisa, levels = top_areas_pesquisa$area_pesquisa_ord, ordered = T)) %>% 
  group_by(periodo, area_pesquisa) %>% 
  summarise(citacoes_databases = sum(citacoes_databases),
            n_artigos = n()) %>% 
  mutate(citacoes_norm = ifelse(n_artigos == 0, 0, citacoes_databases/n_artigos)) %>% 
  mutate(perc_citacoes = citacoes_norm/sum(citacoes_norm),
         perc_artigos = n_artigos/sum(n_artigos))

wos_group_ap = left_join(wos_group_ap, text_color, by = 'area_pesquisa')

# Criando arquivo agrupado do WoS por citações
wos_group_citacoes = wos %>% 
  group_by(PY) %>% 
  summarise(citacoes_databases = sum(citacoes_databases),
            n_artigos = n()) %>% 
  mutate(citacoes_norm = ifelse(n_artigos == 0, 0, citacoes_databases/n_artigos)) %>% 
  na.omit()

# Criando arquivo agrupado do Scopus por ano de publicação
scopus_group <- scopus %>%
  replace(is.na(.),0) %>% 
  group_by(Year) %>% 
  summarise(n_artigos = n(),
            citacoes = sum(Cited.by)) %>% 
  mutate(citacoes_norm = ifelse(n_artigos == 0, 0, citacoes/n_artigos)) %>% 
  replace(is.na(.), 0) %>% 
  mutate(Year = as.character(Year)) %>% 
  rename(citacoes_teste = citacoes) %>% 
  na.omit()