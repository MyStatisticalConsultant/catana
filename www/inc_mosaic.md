#### R codes used to generate results 

Mosaic plot ([vcd](https://cran.r-project.org/web/packages/vcd/vcd.pdf) package): 

``` {r} 
myTable <- table(x, y)
mosaic(myTable, legend=TRUE, shade=TRUE, las=2, col=TRUE)
```

`x` and `y` are vectors. 
