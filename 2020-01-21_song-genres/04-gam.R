library(tidyverse)
library(mgcv)
library(parallel)

load(here::here("2020-01-21_song-genres", "spotify-songs.Rdata"))

songs_df <- spotify_songs %>%
  mutate(
    release_year = substring(
        track_album_release_date, 1, 4
      ) %>%
      as.integer()
  ) %>%
  left_join(
    spotify_songs %>%
      group_by(playlist_id) %>%
      summarise(
        playlist_size = n()
      ),
    by = "playlist_id"
  ) %>%
  left_join(
    spotify_songs %>%
      group_by(track_album_id) %>%
      summarise(
        album_size = n()
      ),
    by = "track_album_id"
  ) %>%
  mutate_at(
    vars(playlist_genre, playlist_subgenre, playlist_name, track_artist, mode, key),
    factor
  )

df <- songs_df %>%
  select(
    -track_id,
    -track_name,
    -track_album_id,
    -track_album_name,
    -track_album_release_date,
    -playlist_name,
    -playlist_id,
    -track_artist
  ) %>%
  mutate_at(
    vars(
    danceability,
    energy,
    loudness,
    speechiness,
    acousticness,
    instrumentalness,
    liveness,
    valence
    ),
    scale
  )

library(caret)

set.seed(2020)
train_idx <- createDataPartition(y = df$playlist_genre, p = .7, list = FALSE)
train_df <- df[train_idx,]
test_df <- df[-train_idx,]

gam_formula <- track_popularity ~ playlist_genre + s(danceability) + s(energy, k = 18)  + s(acousticness, k = 18) + s(instrumentalness, k = 12) + s(release_year, k = 16) + s(liveness, k = 18)

# + s(loudness, k = 32)
# + s(speechiness)
#  + s(valence)
# + s(playlist_size, k = 16) + s(album_size)
#
# + key + mode
#  + s(tempo, k = 16) + s(duration_ms, k = 16) +
set.seed(2020)
cl <- makeCluster(3)
gam_mod <- gam(gam_formula, data = train_df,
               method = "REML", cluster = cl)
stopCluster(cl)
gam.check(gam_mod)

summary(gam_mod)
plot(gam_mod, residuals = TRUE, pages = 1)

pred <- predict(gam_mod, newdata = test_df)
cor(pred, test_df$track_popularity)
