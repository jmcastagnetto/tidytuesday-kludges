library(tidyverse)
library(parallel)
library(caret)

load(here::here("2020-01-21_song-genres", "spotify-songs.Rdata"))

df <- spotify_songs %>%
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
  ) %>%
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

set.seed(2020)
train_idx <- createDataPartition(y = df$playlist_genre, p = .7, list = FALSE)
train_df <- df[train_idx,]
test_df <- df[-train_idx,]

mod1 <- train(
  track_popularity ~ .,
  train_df,
  trControl = trainControl(
    method = "cv",
    number = 10
  ),
  method = ""
)

pred <- predict(mod1, newdata = test_df)
(r <- roc(test_df$track_popularity, pred))
plot(r)
summary(mod1)

