# cross_lag_plot
Code to generate graphs for random-intercept, cross lagged panel model results. 
Based on https://jflournoy.github.io/2017/10/20/riclpm-lavaan-demo/ and 

Hamaker, E. L., Kuiper, R. M., & Grasman, R. P. P. P. (2015). A Critique of the Cross-Lagged Panel Model. 
  Psychological Methods, 20(1), 102–116. https://doi.org/10.1037/a0038889


So far, only works for 3-variable models and omits path between first and third variable for legibility. 
clmp_graph requires the name of the lavaan model and the name of the three variables of interest. 
An optional vector can be used to specify alternative names for the figure. 

Default behavior is that significant paths are printed as a solid line + labels with coefficient estimates are printed. Non-significant paths are printed as a dotted line, and labels are omitted. 




