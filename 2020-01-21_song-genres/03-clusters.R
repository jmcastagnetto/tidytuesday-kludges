library(tidyverse)
library(NbClust)

load(here::here("2020-01-21_song-genres", "spotify-songs.Rdata"))

songs_matrix <- spotify_songs %>%
  select(-c(1:11)) %>%
  scale()

clus_expl <- NbClust(songs_matrix, method = "kmeans")

save(
  clus_expl,
  file = here::here("2020-01-21_song-genres", "clus_expl.Rdata")
)