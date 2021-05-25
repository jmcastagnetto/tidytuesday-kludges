library(tidyverse)
records <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-25/records.csv')
drivers <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-25/drivers.csv')


saveRDS(
  records,
  file = "2021-05-25_mario-kart-records/orig/records.rds"
)

saveRDS(
  drivers,
  file = "2021-05-25_mario-kart-records/orig/drivers.rds"
)
