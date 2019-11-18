library(tidyverse)

datasets <- tidytuesdayR::tt_load("2019-11-19")

nz_bird <- datasets$nz_bird %>%
  mutate(
    vote_rank = str_remove(vote_rank, "vote_") %>% as.integer()
  )

save(
  nz_bird,
  file = here::here("2019-11-19_nz-birds/nz-birds.Rdata")
)

