library(tidyverse)


games <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-03-16/games.csv') %>%
  mutate(
    gamename = iconv(gamename, to='ASCII//TRANSLIT'),
    avg_peak_perc = str_remove(avg_peak_perc, "%"),
    avg_peak_perc = as.double(avg_peak_perc) / 100,
    date = as.Date(paste(year, month, "01", sep = "-"),
                   format = "%Y-%B-%d")
  )
saveRDS(
  games,
  file = "2021-03-16_video_games_steam/games.rds"
)
