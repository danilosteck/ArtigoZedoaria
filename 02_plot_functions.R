barline <- function(df, plotvars, colors, legend_inputs, x.angle = 0){
  yscale = max(df[,plotvars['ysec']])/max(df[,plotvars['yprim']])
  
  df <- df %>% 
    rename_with(.fn = function(x){return('x')}, .cols = dplyr::contains(plotvars['x'])) %>%
    rename_with(.fn = function(x){return('yprim')}, .cols = dplyr::contains(plotvars['yprim'])) %>%
    rename_with(.fn = function(x){return('ysec')}, .cols = dplyr::contains(plotvars['ysec']))

  p <- df %>% ggplot(aes(x=x)) + 
    geom_bar(stat="identity", aes(y=yprim,fill = legend_inputs['yprim'], colour=legend_inputs['yprim']),colour="white")+ #green
    geom_line(aes(y=ysec/yscale,group=1, colour=legend_inputs['ysec']),size=1.0) +   #red
    geom_point(aes(y=ysec/yscale, colour=legend_inputs['ysec']),size=3) +           #red
    scale_colour_manual(name="",values=colors) + 
    scale_fill_manual(name="",values=colors) +
    # theme_bw() +
    labs(x = legend_inputs[1], y = legend_inputs[2], title = legend_inputs[4])+
    scale_y_continuous(sec.axis=sec_axis(~.*yscale,name=legend_inputs[3]))+
    theme(panel.background = element_rect(fill = 'white', colour = 'black')) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
    theme(axis.title.x = element_text(size = 8, vjust=-.2)) +
    theme(axis.text.x = element_text(angle = x.angle))+
    theme(axis.title.y = element_text(size = 8, vjust=0.3))+
    theme(title = element_text(size = 9))+
    theme(legend.key=element_rect(fill=NA))+
    theme(legend.text = element_text(size = 8), legend.position = 'bottom')
  return(p)
}

