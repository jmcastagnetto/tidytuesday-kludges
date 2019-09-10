library(tidyverse)

cpu <- readr::read_csv(
  "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-03/cpu.csv"
  ) %>%
  mutate(
    decade = (date_of_introduction - (date_of_introduction %% 10)) %>% as.factor()
  )

gpu <- readr::read_csv(
  "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-03/gpu.csv"
  ) %>%
  mutate(
    decade = (date_of_introduction - (date_of_introduction %% 10)) %>% as.factor()
  )

ram <- readr::read_csv(
  "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-03/ram.csv"
  ) %>%
  mutate(
    decade = (date_of_introduction - (date_of_introduction %% 10)) %>% as.factor()
  )

save(
  cpu, gpu, ram,
  file = here::here("2019-09-03_moores-law/moores-law.Rdata")
)
