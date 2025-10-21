#### R codes used to generate results 

Association plot ([vcd](https://cran.r-project.org/web/packages/vcd/vcd.pdf) package): 

``` {r} 
myTable <- table(x, y)
assoc(myTable, legend=TRUE, shade=TRUE, col=TRUE)
```

`x` and `y` are vectors. 
