#### R codes used to generate results 

Correspondence analysis results ([ca](https://cran.r-project.org/web/packages/ca/ca.pdf) package): 

``` r 
myTable <- table(x, y)
print(ca(myTable))
```

`x` and `y` are vectors. 
