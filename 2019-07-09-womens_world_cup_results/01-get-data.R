library(tidyverse)

wwc_outcomes <- read_csv(
  "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-07-09/wwc_outcomes.csv"
)

squads <- read_csv(
  "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-07-09/squads.csv"
)

codes <- read_csv(
  "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-07-09/codes.csv"
)

wwc_outcomes <- wwc_outcomes %>%
  left_join(
    codes,
    by = c("team")
  )

save(
  wwc_outcomes, squads, codes,
  file = here::here("2019-07-09-womens_world_cup_results/data/orig/wwc_results.Rdata")
)

