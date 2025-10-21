#### R codes used to generate results 

Loglinear model tests ([MASS](https://cran.r-project.org/web/packages/MASS/MASS.pdf) package):

``` {r} 
myTable <- xtabs(~A+B+C, data=myData) # Three-way contingency table
loglm(~A+B+C, myTable)                # Mutual independence
loglm(~A+B+C+B*C, myTable)            # Partial independence
loglm(~A+B+C+A*C+B*C, myTable)        # Conditional independence
loglm(~A+B+C+A*B+A*C+B*C, myTable)    # No three-way interaction
```

`myData` is a data frame containing all categorical variables. `A`, `B` and `C` are vectors. 
