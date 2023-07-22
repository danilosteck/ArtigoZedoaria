source('03_gerar_plots.R')
library(gridExtra)

p1 <- grid.arrange(p_comp_ap, plt_citacoes_normalizadas, ncol = 2,
                   widths = c(1.5,1))

ggsave(
  plot = p1, 
  filename = file.path(path,glue('citacoesNormalizadas_AreaPesquisa_{Sys.Date()}.png')),
  dpi = 300, 
  width = 13, 
  height = 6.5)

p2 <- grid.arrange(
  p_wos_citacoes,
  p_wos_citacoes_norm,
  nrow = 2
)

ggsave(
  plot = p2, 
  filename = file.path(path,glue('Citacoes_Ano_WoS_{Sys.Date()}.png')),
  dpi = 300, 
  width = 13, 
  height = 8)


p3 <- grid.arrange(
  p_scopus_citacoes,
  p_scopus_citacoes_norm,
  nrow = 2
)

ggsave(
  plot = p3, 
  filename = file.path(path,glue('Citacoes_Ano_Scopus_{Sys.Date()}.png')),
  dpi = 300, 
  width = 13, 
  height = 8)
