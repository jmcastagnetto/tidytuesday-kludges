library(tidyverse)

bloons <- readRDS("2021-03-16_video_games_steam/games.rds") %>%
  filter(str_detect(gamename, "loon"))

ggplot(
  bloons,
  aes(x = date, y = avg)
) +
  geom_line(aes(color = gamename), size = 3)

