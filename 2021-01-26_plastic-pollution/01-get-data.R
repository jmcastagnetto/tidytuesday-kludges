library(tidyverse)

plastics <- vroom::vroom('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-01-26/plastics.csv') %>%
  mutate(
    continent = countrycode::countryname(country, "continent")
  )

saveRDS(
  plastics,
  file = "2021-01-26_plastic-pollution/plastic-pollution.rds"
)
