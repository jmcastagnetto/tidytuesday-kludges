library(tidyverse)
library(txtplot)

load(
  here::here("2019-07-30_video-games/data/video-games.Rdata")
)

# Number of games per release year
games_year <- video_games %>%
  filter(!is.na(release_year)) %>%
  group_by(release_year) %>%
  tally()

txtplot(x = games_year$release_year,
        y = games_year$n,
        xlab = "Release Year",
        ylab = "Games",
        xlim = c(2000, 2020))

# Metascores vs price
txtplot(x = video_games$price,
        y = video_games$metascore,
        xlab = "Price",
        ylab = "Metascore")


# Metascore vs price range
range_0_20 <- (video_games %>%
                 filter(price_range == "(0,20]"))$metascore
range_20_40 <- (video_games %>%
                  filter(price_range == "(20,40]"))$metascore
range_40_600 <- (video_games
                 %>% filter(price_range == "(40,600]"))$metascore

txtboxplot(
  range_0_20, range_20_40, range_40_600,
  xlab = "Metascore distribution by price range"
)

# 95% quantile for price
quantile(video_games$price, probs = 0.97, na.rm = TRUE)
# Price distribution up to 99% quantile
# pricing "sweet spots" ~ 1, 5, 10, 15, 20, 30 (USD)
txtdensity(
  (video_games
   %>% filter(!is.na(price) & price < 30))$price,
  xlab = "Price (USD)"
)

