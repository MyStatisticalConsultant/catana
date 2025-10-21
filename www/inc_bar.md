#### R codes used to generate results 

Bar chart: 

``` r 
counts <- table(x)
barplot(counts, main="Main title", xlab="Horizontal axis title")
```

`x` is a vector or matrix. 

Horizontal bar chart: 

``` r 
counts <- table(x)
barplot(counts, horiz = TRUE, main="Main title")
```

Stacked bar chart: 

``` r 
counts <- table(x, y)
barplot(counts, col=c("blue", "red"), legend=rownames(counts), main="Main title", xlab="Horizontal axis title")
```

`x` and `y` are vectors. 

Grouped bar chart: 

``` r 
counts <- table(x, y)
barplot(counts, beside=TRUE, col=c("blue", "red"), legend=rownames(counts), main="Main title", xlab="Horizontal axis title")
```

`x` and `y` are vectors. 
