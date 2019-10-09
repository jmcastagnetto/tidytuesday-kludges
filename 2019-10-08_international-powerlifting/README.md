The dataset used in these plots comes from the TidyTuesday repo at: https://github.com/rfordatascience/tidytuesday/tree/master/data/2019/2019-10-08

Look at [`01-get-and-mangle-data.R`](01-get-and-mangle-data.R) to see how I put the data into long ("tidy") form, what I removed from the dataset (rows without information on the weight lifted, for example), etc.

The GLM and LASSO models are very 'quick-and-dirty', and just meant to (a) see if predicting weight lifted could be done, and (b) serve as an excuse to play a bit with the `recipes` package.
