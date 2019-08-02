library(tidyverse)
library(txtplot)

load(
  here::here("2019-07-30_video-games/data/video-games.Rdata")
)

tmp <- video_games %>% filter(!is.na(release_year))
txtdensity(tmp$release_year)
txtbarchart(as.factor(tmp$release_year))

txtplot(tmp$price,
        tmp$metascore, xlab = "Price", ylab = "Metascore")
txtcurve(1*x, from = 0, to = 70)


pr1 <- tmp %>% filter(price_range == "(0,20]")
pr2 <- tmp %>% filter(price_range == "(20,40]")
pr3 <- tmp %>% filter(price_range == "(40,600]")

range_0_20 <- pr1$metascore
range_20_40 <- pr2$metascore
range_40_600 <- pr3$metascore

txtboxplot(
  range_0_20, range_20_40, range_40_600,
  xlab = "Metascore by price ranges"
)
