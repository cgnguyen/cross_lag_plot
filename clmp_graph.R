#Note Requires the following packages

library(tidyverse)
library(ggplot2)
library(directlabels)
library(ggfittext)


clmp_graph<-function(model_name,var_names,var_labels){
  #Check for optional parameter variable labels
  if(missing(var_labels)) {
    var_labels<-var_names 
  } else {
  }
  
  #Generate Boxes (make this more modular later) 
  boxes=data.frame(
    x1=c(1,4,1,4,1,4), 
    x2=c(2,5,2,5,2,5), 
    y1=c(1,1,3,3,5,5), 
    y2=c(2,2,4,4,6,6))
  
  auto.arrows <- data.frame(
    x1=c(2,2,2), 
    x2=c(4,4,4), 
    y1=c(1.5,3.5,5.5), 
    y2=c(1.5,3.5,5.5))
  
  #Extract Model
  model_lavaan<-parameterEstimates(model_name)
  
  #Generate names for exclusion  
  var_regex<-paste("(",paste(var_names,collapse = "|"),")", sep="")
  
  #Simplify Results: Only take regression results, condense yearly data, and drop rest, 
  #order left variables to be in order of variables specified above
  model_lavaan<-model_lavaan %>%
    filter(op =="~")  %>%
    extract(data=., col=lhs, into="depvar", regex=var_regex,remove=F) %>%
    extract(data=., col=rhs, into="indepvar", regex=var_regex,remove=F) %>%
    select(depvar,indepvar,est,pvalue) %>%
    distinct(depvar,indepvar, .keep_all = T) %>%
    mutate(type = ifelse(pvalue < 0.05, "solid", "dotted")) %>%
    mutate(label=round(est,3)) %>% 
    mutate(stars = case_when(
      pvalue>0.05 ~"",
      pvalue<0.05 & pvalue >0.01  ~ "*", 
      pvalue<0.01 & pvalue >0.001  ~ "**",  
      pvalue<0.001 ~ "***")) %>%
    mutate(labels=paste(label,stars, sep=""))
  
  #Results for autoregressive paths
  auto.arrows<-model_lavaan %>%
    filter(depvar==indepvar) %>%
    select(labels,type) %>%
    bind_cols(.,auto.arrows) %>%
    filter(type=="solid")
  
  #Name Boxes
  boxes$labels<-  rep(var_labels, each=nrow(boxes)/length(var_labels))
  
  ##Name cross lagged paths
  #Generate base frame (exclude path from 3 to 1 and vice versa for legibility)
  model_cross<-model_lavaan %>%
    filter(depvar!=indepvar) %>%
    filter(depvar != var_names[1] | indepvar != var_names[3])%>%
    filter(depvar != var_names[3] | indepvar!=var_names[1])
  model_cross
  
  #Generate Arrows 
  crosslag.arrows<-data.frame(
    x1=c(2,2,2,2), 
    x2=c(4,4,4,4), 
    y1=c(2,5,3,4), 
    y2=c(3,4,2,5),
    desc =c("1 to 2","3 to 2","2 to 1","2 to 3"))
  
  #Copy line type
  crosslag.arrows<-cbind(model_cross,crosslag.arrows)
  
  #Label Crosslag.labels
  
  crosslag.labels<-data.frame(
    x1=c(2.5,2.5,2.5,2.5), 
    y1=c(2.25,4.75,2.75,4.25),
    desc =c("1 to 2","3 to 2","2 to 1","2 to 3"))
  
  crosslag.labels$labels<-model_cross$est
  crosslag.labels$type<-model_cross$type
  
  crosslag.labels<-crosslag.labels %>%
    mutate(labels=round(labels,3)) %>%
    filter(type=="solid")
  
  #Generate Graph 
  ggplot() + 
    scale_x_continuous(name="") + 
    scale_y_continuous(name="") +
    theme_bw()+
    theme(panel.grid.minor = element_blank(), 
          panel.grid.major = element_blank(), 
          panel.border =  element_blank(), 
          legend.position="none",
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank())+
    geom_rect(data=boxes, mapping=aes(xmin=x1, xmax=x2, ymin=y1, ymax=y2), color="black", fill="white",alpha=1)+
    geom_fit_text(data=boxes, mapping=aes(xmin=x1, xmax=x2, ymin=y1, ymax=y2, label=labels))+
    geom_segment(data=auto.arrows,aes(x=x1, y=y1, xend=x2,yend=y2, linetype=type),
                 arrow = arrow(length = unit(0.5,"cm")),
                 linetype= auto.arrows$type)+
    geom_label(data=auto.arrows, aes(x=x1+1, y=y1,label=labels))+
    geom_segment(data=crosslag.arrows,aes(x=x1, y=y1, xend=x2,yend=y2,linetype=type),
                 linejoin='mitre', 
                 arrow = arrow(length = unit(0.5,"cm")),
                 linetype= crosslag.arrows$type)+
    geom_label(data=crosslag.labels, aes(x=x1, y=y1,label=labels))
}