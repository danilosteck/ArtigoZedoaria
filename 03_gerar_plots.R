# Carregar arquivos e pacotes
source('01_carregar_bases.R')
source('02_plot_functions.R')

library(ggplot2)
library(plotly)
library(jtools)
library(glue)
library(hrbrthemes)


# Criar pasta para armazenar as imagens geradas
path <- file.path('.','figs',Sys.Date())
if(!dir.exists(path)){
  dir.create(path)
}

# Citações normalizadas (citações / número de artigos)
plt_citacoes_normalizadas <- wos_group %>% 
  ggplot(aes(x = reorder(area_pesquisa,n_artigos), y = citacoes_norm))+
  geom_bar(stat = 'identity', fill = viridis::viridis(1))+
  geom_text(aes(label = round(citacoes_norm,1)), hjust = -0.1)+
  ylim(c(0, ceiling((max(wos_group$citacoes_norm)+10)/10)*10))+
  theme(panel.background = element_rect(fill = 'white', colour = 'black')) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  labs(x = 'Área de pesquisa (WoS)', y = 'Citações por artigo', title = '(b) Citações por artigo vs. área de pesquisa')+
  theme(plot.title = element_text(hjust = 2))+
  coord_flip();plt_citacoes_normalizadas

# Comparação por áreas de pesquisa
p_comp_ap <- wos_group_ap %>% 
  ggplot(aes(x = periodo, y = perc_artigos))+
  geom_bar(aes(fill = fct_rev(area_pesquisa)), position = 'stack', stat = 'identity')+
  scale_fill_viridis_d()+
  geom_text(aes(label = glue('{substr(area_pesquisa,1,12)}. : {scales::percent(perc_artigos,.1)}'), y=perc_artigos), 
            position = position_stack(vjust = 0.5),
            color = wos_group_ap$color,
            size = 3)+
  scale_y_percent()+
  labs(x = 'Período', y = 'Percentual acumulado de Artigos', fill = 'Área de Pesquisa (top 15)', title = '(a) Área de pesquisa por período'); p_comp_ap

# Plots por ano

cols <- viridis::viridis(2, begin = 0.25, end = 0.7,option = 'inferno')
cols <- c(cols[1],cols[2])

# WOS Viewer
plotvars_cn <- c(x = 'PY', yprim = 'n_artigos', ysec = 'citacoes_norm')
legvars_cn <- c(x = 'Ano Publicação',yprim = 'Nº Artigos',ysec = 'Citações por artigo', title = '(b) Artigos publicados e Citações normalizadas por ano de publicação (WoS)')

names(cols) <- c(legvars_cn['yprim'], legvars_cn['ysec'])
p_wos_citacoes_norm <- barline(wos_group_citacoes, plotvars_cn, cols, legvars_cn);p_wos_citacoes_norm


plotvars <- c(x = 'PY', yprim = 'n_artigos', ysec = 'citacoes_databases')
legvars <- c(x = 'Ano Publicação',yprim = 'Nº Artigos',ysec = 'Citações', title = '(a) Artigos publicados e Citações por ano de publicação (WoS)')
names(cols) <- c(legvars['yprim'], legvars['ysec'])
p_wos_citacoes <- barline(wos_group_citacoes, plotvars, cols, legvars);p_wos_citacoes

# Scopus
plotvars <- c(x = 'Year', yprim = 'n_artigos', ysec = 'citacoes_norm')
legvars <- c(x = 'Ano Publicação',yprim = 'Nº Artigos',ysec = 'Citações por artigo', title = '(b) Artigos publicados e Citações normalizadas por ano de publicação (Scopus)')
names(cols) <- c(legvars['yprim'], legvars['ysec'])
p_scopus_citacoes_norm <- barline(scopus_group, plotvars, cols, legvars,x.angle = 90);p_scopus_citacoes_norm

plotvars <- c(x = 'Year', yprim = 'n_artigos', ysec = 'citacoes_teste')
legvars <- c(x = 'Ano Publicação',yprim = 'Nº Artigos',ysec = 'Citações', title = '(a) Artigos publicados e Citações normalizadas por ano de publicação (Scopus)')
names(cols) <- c(legvars['yprim'], legvars['ysec'])
p_scopus_citacoes <- barline(scopus_group, plotvars, cols, legvars, x.angle = 90);p_scopus_citacoes

