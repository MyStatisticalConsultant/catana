#### R codes used to generate results 

Correspondence analysis plot ([ca](https://cran.r-project.org/web/packages/ca/ca.pdf) package): 

``` {r} 
myTable <- table(x, y)
plot(ca(myTable))
```

`x` and `y` are vectors.
