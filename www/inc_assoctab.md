#### R codes used to generate results 

Association statistics ([vcd](https://cran.r-project.org/web/packages/vcd/vcd.pdf) package): 

``` {r}
myTable <- table(x, y)
summary(assocstats(myTable))
```

`x` and `y` are vectors. 

