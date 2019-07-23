# library(tidyverse)

# bird_impacts <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-07-23/bird_impacts.csv") %>%
#   mutate(
#     phase_of_flt = str_to_lower(phase_of_flt),
#     damage = replace_na(damage, "U") # unknown
#   )
#
# save(
#   bird_impacts,
#   file = here::here("2019-07-23_bird-impacts/data/bird_impacts.Rdata")
# )

# data dictionary
download.file(
  "https://wildlife.faa.gov/downloads/fieldlist.xls",
  destfile = here::here("2019-07-23_bird-impacts/data/fieldlist.xls")
)

# original data in MS Access Format
download.file(
  "https://wildlife.faa.gov/downloads/wildlife.zip",
  destfile = here::here("2019-07-23_bird-impacts/data/wildlife.zip")
)

# see README.md for command line processing of the database