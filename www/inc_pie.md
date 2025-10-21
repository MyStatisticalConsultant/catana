#### R codes used to generate results 

[Pie](https://stat.ethz.ch/R-manual/R-devel/library/graphics/html/pie.html) chart displaying label and percentage for each slice: 

``` r 
myTable <- table(x)
percentlabels <- round(100*myTable/sum(myTable), 1)
labs <- paste(names(myTable), "\n", percentlabels, "%", sep="")
pie(myTable, labels=labs, col=rainbow(length(levels(x))), main="Main title")
```

`x` is a vector with observations of a categorical variable. 
