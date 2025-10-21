#### R codes used to generate results 

Descriptive statistics (base package): 

``` r 
summary(x)
```

`x` is a data frame. 

Descriptive statistics (psych package): 

``` r 
describe(x, skew=FALSE, ranges=FALSE)
``` 

Descriptive statistics grouped by one the of categorical variables (psych package): 

``` r 
describeBy(x, group=y, skew=FALSE, ranges=FALSE)
```

`y` is a categorical variable. 
