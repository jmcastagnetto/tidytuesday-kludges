library(tidyverse)
library(factoextra)
library(NbClust)
library(corrplot)

load(here::here("2020-01-21_song-genres", "spotify-songs.Rdata"))

songs_matrix <- spotify_songs %>%
  select(-c(1:11)) %>%
  scale()

# check the correlation
corrs <- cor(songs_matrix)
corrplot(corrs, method = "ellipse",
         add = FALSE, diag = TRUE)

pca_mod <- prcomp(songs_matrix, center = FALSE)
summary(pca_mod)

s1 <- pca_mod$x[sample(nrow(pca_mod$x), 1000),]

# make 10,000 runs each sampling 500 songs
# and estimate the best cluster in each run
# then check the distribution.

s1 <- songs_matrix[sample(nrow(songs_matrix), 1000),]

# results to big to fit on my computer's memory
clus_expl <- NbClust(s1, method = "kmeans")

set.seed(2020)
p1 <- fviz_nbclust(s1, kmeans, method = "gap_stat")

p1save(
  p1,
  file = here::here("2020-01-21_song-genres", "clus_expl.Rdata")
)