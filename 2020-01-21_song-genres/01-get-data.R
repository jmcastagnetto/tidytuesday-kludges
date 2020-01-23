library(tidyverse)

spotify_songs <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-01-21/spotify_songs.csv')


spotify_songs <- spotify_songs %>%
  filter(!is.na(track_name))

skimr::skim(spotify_songs)

save(
  spotify_songs,
  file = here::here("2020-01-21_song-genres", "spotify-songs.Rdata")
)
