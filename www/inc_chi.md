#### R codes used to generate results 

[Chi-squared test](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/chisq.test.html):

``` {r} 
myTable <- table(x, y)
chisq.test(myTable)
```

`x` and `y` are vectors. 
