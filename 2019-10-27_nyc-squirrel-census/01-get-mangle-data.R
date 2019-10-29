library(tidyverse)
nyc_squirrels <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-29/nyc_squirrels.csv")

sq_activ <- nyc_squirrels %>%
  select(long, lat, shift,
         kuks, quaas, moans,
         running, chasing, climbing, eating, foraging,
         tail_flags, tail_twitches
         )

sq_activ_long <- sq_activ %>%
  mutate(
    making_noise = kuks | quaas | moans,
    moving_around = running | chasing | climbing,
    chowing_down = eating | foraging
  ) %>%
  select(
    long, lat, shift,
    making_noise, moving_around, chowing_down
  ) %>%
  pivot_longer(
    cols = c(making_noise, moving_around, chowing_down),
    names_to = "activity",
    values_to = "effected"
  )

save(
  nyc_squirrels,
  sq_activ,
  sq_activ_long,
  file = here::here("2019-10-27_nyc-squirrel-census/nyc-squirrels.Rdata")
)

