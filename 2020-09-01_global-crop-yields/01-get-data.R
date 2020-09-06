library(tidyverse)
library(ggcorrplot)

data <- tidytuesdayR::tt_load('2020-09-01')

saveRDS(
  data,
  file = "2020-09-01_global-crop-yields/data/20200901-global-crop-yields.rds"
)
