#### R codes used to generate results 

Take a simple random sample: 

``` {r} 
set.seed(10)         # initiate the random number generator
data[sample(1:nrow(data), size=sampleSize, replace=FALSE),]
```

`data` is a data frame from where a simple random sample without replacement is taken. 
