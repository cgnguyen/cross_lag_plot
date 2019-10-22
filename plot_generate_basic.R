

####
needs(ggplot2)
needs(directlabels)
needs(ggfittext)
x

#Generate Boxes (make this more modular later) 
boxes=data.frame(
  x1=c(1,1,4,4,1,4), 
  x2=c(2,2,5,5,2,5), 
  y1=c(1,3,1,3,5,5), 
  y2=c(2,4,2,4,6,6),
  labels=c("1","2","3","4","5","6"))

auto.arrows <- data.frame(
  x1=c(2,2,2), 
  x2=c(4,4,4), 
  y1=c(1.5,3.5,5.5), 
  y2=c(1.5,3.5,5.5),
  labels=c("1","2","3"))

auto.labels<- <- data.frame(
  x1=c(2,2,2), 
  y1=c(1.5,3.5,5.5), 
  labels=c("1","2","3"))

crosslag.arrows<-data.frame(
  x1=c(2,2,2,2), 
  x2=c(4,4,4,4), 
  y1=c(5,4,2,3), 
  y2=c(4,5,3,2))


crosslag.labels<-data.frame(
  x1=c(2.5,2.5,2.5,2.5), 
  y1=c(4.75,4.25,2.75,2.25), 
  labels=c("A***","B**","C**",""))


ggplot() + 
  scale_x_continuous(name="") + 
  scale_y_continuous(name="") +
  geom_rect(data=boxes, mapping=aes(xmin=x1, xmax=x2, ymin=y1, ymax=y2), color="black", fill="white",alpha=1)+
  geom_fit_text(data=boxes, mapping=aes(xmin=x1, xmax=x2, ymin=y1, ymax=y2, label=labels))+
  geom_segment(data=auto.arrows,aes(x=x1, y=y1, xend=x2,yend=y2), arrow = arrow(length = unit(0.5,"cm")))+
  geom_label(data=auto.arrows, aes(x=x1+1, y=y1,label=labels))+
  geom_segment(data=crosslag.arrows,aes(x=x1, y=y1, xend=x2,yend=y2), arrow = arrow(length = unit(0.5,"cm")))+
  geom_label(data=crosslag.labels, aes(x=x1, y=y1,label=labels))+
  theme_bw()+
  theme(panel.grid.minor = element_blank(), panel.grid.major = element_blank(), 
        legend.position="none",
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())



  

