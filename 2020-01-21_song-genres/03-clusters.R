library(tidyverse)
#library(factoextra)
library(NbClust)
#library(corrplot)

load(here::here("2020-01-21_song-genres", "spotify-songs.Rdata"))

get_modes <- function(x) {
  ux <- unique(x)
  tab <- tabulate(match(x, ux))
  ux[tab == max(tab)]
}

songs_matrix <- spotify_songs %>%
  select(-c(1:11)) %>%
  scale()

# check the correlation
# corrs <- cor(songs_matrix)
# corrplot(corrs, method = "ellipse",
#          add = FALSE, diag = TRUE)


# pca_mod <- prcomp(songs_matrix, center = FALSE)
# summary(pca_mod)
#
# s1 <- pca_mod$x[sample(nrow(pca_mod$x), 1000),]
#
# Not sure PCA will give much help, seems like if
# we want to explain > 90% variability we need PC1:PC10
# and for > 80% PC1:PC8
# nclus_pca80 <- NbClust(s1, method = "complete")
# # best number of clusters = 2
# get_modes(nclus_pca80$Best.nc[1,])

# p1 <- fviz_nbclust(s1, kmeans, method = "gap_stat", nboot = 100, )


# results to big to fit on my computer's memory
# so need get samples
#
# make 200 runs each sampling 500 songs
# and estimate the best cluster in each run
# then check the distribution.
set.seed(2020)
nruns <- 200
nsamples <- 500
clus_size_results <- integer()
for (i in 1:nruns) {
  sampl <- songs_matrix[sample(nrow(songs_matrix), nsamples),]
  dummy <- capture.output({
  nclus_calc <- NbClust(sampl, method = "kmeans", max.nc = 10)
  })
  nopt_clus <- get_modes(nclus_calc$Best.nc[1,])
  clus_size_results <- append(clus_size_results, nopt_clus)
  print(sprintf("Run: %d, optimal value: %d", i, nopt_clus))
}

#
# r6 <-  kmeans(songs_matrix, 6, iter.max = 50, nstart = 10)
# pca_mod <- prcomp(songs_matrix, center = FALSE)
# summary(pca_mod)
# plot(pca_mod$x[,2:3], col = r6$cluster, cex = .5, pch = 20)
#
# r2 <-  kmeans(songs_matrix, 2, iter.max = 50, nstart = 10)
# plot(pca_mod$x[,1:2], col = r2$cluster, cex = .5, pch = 20)
#
# r7 <-  kmeans(songs_matrix, 7, iter.max = 50, nstart = 10)
# plot(pca_mod$x[,1:2], col = r7$cluster, cex = .5, pch = 20)
#

save(
  clus_size_results,
  file = "clus_size_results.Rdata"
  #file = here::here("2020-01-21_song-genres", "clus_size_results.Rdata")
)