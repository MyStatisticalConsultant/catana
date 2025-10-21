#### R codes used to generate results 

Agreement plot ([vcd](https://cran.r-project.org/web/packages/vcd/vcd.pdf) package): 

``` {r} 
myTable <- table(x, y)
agreementplot(myTable)
```

`x` and `y` are vectors. 
