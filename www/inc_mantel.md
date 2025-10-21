#### R codes used to generate results 

[Mantel-Haenszel test](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/mantelhaen.test.html):
``` {r}
myTable <- table(x, y, z)
mantelhaen.test(myTable, conf.level = 0.95)
```

`x`, `y` and `z` are vectors. 
