#### R codes used to generate results 

[Exact binomial test](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/binom.test.html): 

``` r 
binom.test(x, n, p = 0.5, alternative = c("two.sided", "less", "greater"), conf.level = 0.95)
```

`x` is a number of successes, `n` is a number of trials, `p` is a hypothesised probability of success.  
