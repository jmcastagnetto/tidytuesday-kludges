library(tidyverse)
library(ggtext)
library(emojifont)
library(sysfonts)
library(magick)
library(cowplot)

font_add_google("Quattrocento")
font_add_google("Special Elite")
font_add_google("Cousine")
emojifont::load.emojifont("OpenSansEmoji.ttf")

bloons <- readRDS("2021-03-16_video_games_steam/games.rds") %>%
  filter(str_detect(gamename, "loon")) %>%
  mutate(
    label = emojifont::emoji("balloon")
  )

comment <- data.frame(
  label = "<span style='color: orange;'>**BTD6**</span> has experienced an almost exponential growth on Steam, compared to more established titles in the \"**Bloons**\" franchise.<br/><br/>Even though it has been avaliable _only since the end of 2018_, it has already surprassed <span style='color: blue;'>BTD5</span> (available since 2014) and <span style='color: red;'>BTD Battles</span> (available since 2016) in average number of users, and perhaps has impacted negatively in the more recent, 2020 title, <span style='color: brown;'>\"Bloons Monkey City\"</span>.",
  x = as.Date("2015-01-01"),
  y = 9200
)

p1 <- ggplot(
  bloons %>% filter(year < 2021),
  aes(x = date, y = avg, group = gamename, color = gamename)
) +
  geom_text(aes(label = label),
            family="OpenSansEmoji", size = 3, alpha = .6) +
  geom_smooth(se = FALSE, method = "loess", span = .6, size = 1)  +
  scale_y_log10() +
  annotation_logticks(sides = "l") +
  scale_color_manual(
    values = c("brown", "orange", "red", "blue")
  ) +
  geom_textbox(
    data = comment,
    aes(x = x, y = y, label = label),
    family = "Quattrocento",
    box.size = 0,
    inherit.aes = FALSE,
    hjust = 0,
    vjust = 1,
    size = 8,
    width = unit(.67, "npc"),
    fill = rgb(1, 1, 1, .2)
  ) +
  labs(
    color = "",
    y = "Average number of users",
    x = "",
    title = "Battle of the Bloons on Steam",
    subtitle = "2021-03-16 #TidyTuesday",
    caption = "Background image from the BTD6 official site (https://btd6.com/)\nMade for my sons who love these games -- @jmcastagnetto, Jesus M. Castagnetto"
  ) +
  theme_minimal(base_size = 26, base_family = "Special Elite") +
  theme(
    plot.title.position = "plot",
    plot.margin = unit(rep(.5, 4), "cm"),
    plot.caption = element_text(family = "Cousine"),
    legend.position = "none",
    panel.grid = element_blank()
  )

# background
img <- image_read("2021-03-16_video_games_steam/BTD6_Logo_Wallpaper_1920x1080.jpeg") %>%
  image_colorize(opacity = 80, "white")

# compose final plot
ggdraw() +
  draw_image(img) +
  draw_plot(p1)

