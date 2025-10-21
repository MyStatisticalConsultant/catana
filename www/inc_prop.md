#### R codes used to generate results 

[Test of equal or given proportions](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/prop.test.html): 

``` r 
prop.test(x, n, p, alternative=c("two.sided", "less", "greater"), conf.level=0.95, correct=TRUE)
```

`x` is a vector of counts of successes, `n` is a vector of counts of trials, `p` is a vector of probabilities of success. If `p` is given and there are more than 2 groups, the null tested is that the underlying probabilities of success are those given by `p`. The alternative is always `two.sided`, the returned confidence interval is NULL, and continuity correction is never used. 
