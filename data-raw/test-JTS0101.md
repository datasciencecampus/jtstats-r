
``` r
library(jtstats)
jts0101_geo = get_jts(code = "JTS0101")
jts0101_geo
```

    ## # A tibble: 35 × 13
    ##    Year  Mode      Place…¹ Place…² Place…³ Prima…⁴ Secon…⁵ Furth…⁶    GP Hospi…⁷
    ##    <chr> <chr>       <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl> <dbl>   <dbl>
    ##  1 2014  Public T…     9.7    12.7    32.6     9.2    17.5    19.9  10.8    36.7
    ##  2 <NA>  Cycle         9.2    10.9    32.7     8.7    13.9    16.3   9.3    24.1
    ##  3 <NA>  Car           7.6     8.5    17.2     7.6    10.2    11.1   7.9    17.7
    ##  4 2015  Public T…     9.8    12.7    32.7     9.3    17.7    20.1  11      38.5
    ##  5 <NA>  Cycle         9.2    10.8    32.2     8.7    13.9    16.3   9.7    34.5
    ##  6 <NA>  Car           7.5     8.3    16.8     7.5    10      10.9   7.7    18.5
    ##  7 2016  Public T…    12.9    13.4    32.9     9.8    18.2    21.1  11      38.5
    ##  8 <NA>  Cycle         9.3    11      33.7     8.7    13.9    16.7   9.9    34.7
    ##  9 <NA>  Car           7.7     8.6    18.4     7.6    10.3    11.6   8      19.6
    ## 10 2017  Public T…     9.4    12      32.2     9.3    18.4    21.4  12.9    39  
    ## # … with 25 more rows, 3 more variables: `Food store` <dbl>,
    ## #   `Town Centres` <dbl>, ...13 <chr>, and abbreviated variable names
    ## #   ¹​`Places with 100-499 jobs`, ²​`Places with 500-4999 jobs`,
    ## #   ³​`Places with 5000 or more jobs`, ⁴​`Primary school`, ⁵​`Secondary school`,
    ## #   ⁶​`Further Education`, ⁷​Hospital
