library(tidyverse)

games <-readRDS("2021-03-16_video_games_steam/games.rds")
most_played <- readRDS("2021-03-16_video_games_steam/games.rds") %>%
  arrange(year, month, avg) %>%
  group_by(year, month) %>%
  mutate(
    rank = rank(avg)
  ) %>%
  filter(rank == max(rank)) %>%
  mutate(
    gamename = case_when(
      gamename == "PLAYERUNKNOWN'S BATTLEGROUNDS" ~ "PUBG",
      gamename == "Counter-Strike: Global Offensive" ~ "CS:GO",
      TRUE ~ gamename
    )
  )

p1 <- ggplot(
  most_played %>% filter(year < 2021),
  aes(y = date, color = gamename)
) +
  geom_segment(aes(yend = date, x = 0, xend = avg/1e6), linetype = "dashed") +
  geom_point(aes(x = avg/1e6), shape = "💥", size = 3) +
  geom_text(aes(x = avg/1e6, label = str_trim(gamename)),
            hjust = 0, nudge_x = .1) +
  scale_color_brewer(palette = "Dark2") +
  scale_y_date(date_labels = "%b", date_breaks = "1 month") +
  scale_x_continuous(labels = scales::comma, limits = c(0, 2)) +
  facet_wrap(~year, scales = "free_y", nrow = 2,
             shrink = TRUE, strip.position = "left") +
  labs(
    x = "Average number of players (in millions)",
    y = "",
    title = "The most played games on Steam from 2012-2020",
    subtitle = "or \"Let's plot Dota 2, PUBG and CS:GO\" 👾 2021-03-16 #TidyTuesday",
    caption = "@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  hrbrthemes::theme_tinyhand(
    base_size = 16,
    plot_title_size = 20,
    subtitle_family = 18,
    caption_family = "Inconsolata",
    strip_text_face = "bold",
    axis_text_size = 12,
    axis_title_size = 16,
    caption_size = 16,
    grid = FALSE,
    plot_margin = margin(.5, .5, .5, .5, "cm")
  ) +
  theme(
    plot.title.position = "plot",
    axis.text.x = element_text(size = 9),
    legend.position = "none"
  )

ggsave(
  plot = p1,
  filename = "2021-03-16_video_games_steam/most-played-games-2014-2020.png",
  width = 16,
  height = 9
)
