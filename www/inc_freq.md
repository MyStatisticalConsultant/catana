#### R codes used to generate results 

Frequency/contingency table: 

``` {r} 
myTable <- table(x, y) # x will be rows, y will be columns
```

Expected frequencies:

``` {r}
independence_table(myTable, frequency = c("absolute"))
independence_table(myTable, frequency = c("relative"))
```

Marginal frequencies: 

``` {r}
margin.table(myTable, 1) # x frequencies (summed over y)
margin.table(mytable, 2) # y frequencies (summed over x)
```

Tables of proportions: 

``` {r}
prop.table(myTable)    # cell percentages
prop.table(myTable, 1) # row percentages
prop.table(myTable, 2) # column percentages 
```
