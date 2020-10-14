# TidyTuesday
# https://github.com/rfordatascience/tidytuesday/tree/master/data/2020/2020-10-13
#
datasaurus <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-10-13/datasaurus.csv')

saveRDS(
  datasaurus,
  file = "2020-10-13_datasaurus-dozen/datasaurus-dozen.rds"
)
