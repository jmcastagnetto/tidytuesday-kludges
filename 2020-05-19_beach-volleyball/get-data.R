library(tidyverse)

vb_matches <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-19/vb_matches.csv', guess_max = 76000)

save(
  vb_matches,
  file = here::here("2020-05-19_beach-volleyball/beach-volleyball.Rdata")
)
