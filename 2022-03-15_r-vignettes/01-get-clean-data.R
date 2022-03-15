library(tidyverse)

bioc <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-03-15/bioc.csv')

bioc_mod <- bioc %>%
  mutate(
    year = lubridate::year(date)
  )

cran <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-03-15/cran.csv')

cran_mod <- cran %>%
  mutate(
    date_clean = as.Date(date),
    date_clean = if_else(
      is.na(date_clean),
      as.Date(date, format = "%c"), # try the non ISO format %c
      date_clean
    )
  ) %>%
  filter(!is.na(date_clean)) %>% # remove entries w/o date
  select(-date) %>%
  rename(
    date = date_clean
  ) %>%
  mutate(
    year = lubridate::year(date)
  )

saveRDS(cran_mod, "2022-03-15_r-vignettes/cran-vignettes.rds")
saveRDS(bioc_mod, "2022-03-15_r-vignettes/bioc-vignettes.rds")
