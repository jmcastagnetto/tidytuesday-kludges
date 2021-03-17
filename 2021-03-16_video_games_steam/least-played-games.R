library(tidyverse)

least_played <- games %>%
  arrange(year, month, avg) %>%
  group_by(year, month) %>%
  mutate(
    rank = rank(avg)
  ) %>%
  filter(rank == 1)

p1 <- ggplot(
  least_played %>% filter(between(year, 2014, 2020)),
  aes(y = date)
) +
  geom_segment(aes(yend = date, x = 0, xend = avg)) +
  geom_point(aes(x = avg)) +
  geom_text(aes(x = avg, label = str_trim(gamename)),
            hjust = 0, nudge_x = 0.1, color = "grey30") +
  scale_y_date(date_labels = "%b", date_breaks = "1 month") +
  scale_x_continuous(limits = c(0, 2)) +
  facet_wrap(~year, scales = "free_y", nrow = 2,
             shrink = TRUE, strip.position = "left") +
  labs(
    x = "Average number of players",
    y = "",
    title = "The least played games on Steam from 2014-2020",
    subtitle = "2021-03-16 #TidyTuesday",
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
    plot.title.position = "plot"
  )
#p1
ggsave(
  plot = p1,
  filename = "2021-03-16_video_games_steam/least-played-games-2014-2020.png",
  width = 16,
  height = 9
)
