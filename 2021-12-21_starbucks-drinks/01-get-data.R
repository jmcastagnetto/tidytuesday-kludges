library(tidyverse)

starbucks <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-12-21/starbucks.csv') %>%
  mutate(
    trans_fat_g = as.numeric(trans_fat_g),
    fiber_g = as.numeric(fiber_g),
    caffeine_mg_per_ml = caffeine_mg / serv_size_m_l,
    calories_per_ml = calories / serv_size_m_l
  )

saveRDS(
  starbucks,
  file = "2021-12-21_starbucks-drinks/starbucks-drinks.rds"
)
