library(tidyverse)

firsts_raw <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-06-09/firsts.csv')
science_raw <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-06-09/science.csv')

save(
  firsts_raw,
  science_raw,
  file = here::here("2020-06-09_african_american_achievements/african-american-achievements.Rdata")
)
