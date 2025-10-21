#### R codes used to generate results 

[Fisher exact test](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/fisher.test.html):

``` {r} 
myTable <- table(x, y)
fisher.test(myTable, conf.int = TRUE, conf.level = 0.95, workspace=2e+6, hybrid=TRUE)
```

`x` and `y` are vectors. 
