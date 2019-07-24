r4ds_members <- readr::read_csv(
  "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-07-16/r4ds_members.csv"
)
save(
  r4ds_members,
  file = here::here("2019-07-16_r4ds-members/data/r4ds_members.Rdata")
)
