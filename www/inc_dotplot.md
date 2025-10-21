#### R codes used to generate results 

Dotplot in [lattice](https://cran.r-project.org/web/packages/lattice/lattice.pdf) package: 

``` r 
myTable <- table(x, y)
dotplot(myTable, groups=FALSE, auto.key=list(lines=TRUE), type=c("p", "h"), xlab="Frequency",
		prepanel = function (x, y) {
	    list(ylim = levels(reorder(y, x)))
	    }, 
	    panel = function(x, y, ...){
	    panel.dotplot(x, reorder(y,x), ...)
		})
```

`x` and `y` are vectors. 
