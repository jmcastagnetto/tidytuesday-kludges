library(tidyverse)
library(ggridges)

records <- readRDS("2021-05-25_mario-kart-records/orig/records.rds")

plot_df <- records %>%
  mutate(
    duration_grp = case_when(
      between(record_duration, 0, 0) ~ "Not even a day",
      between(record_duration, 1, 7) ~ "From one day to a week",
      between(record_duration, 8, 30) ~ "More than a week, to a month",
      between(record_duration, 31, 180) ~ "More than a month, to half a year",
      between(record_duration, 181, 365) ~ "More than half a year to a year",
      between(record_duration, 366, 365*5+1) ~ "More than a year to five years",
      between(record_duration, 365*5+1, max(record_duration)) ~ "More than five years"
    ) %>%
      factor(
        levels = c(
          "Not even a day",
          "From one day to a week",
          "More than a week, to a month",
          "More than a month, to half a year",
          "More than half a year to a year",
          "More than a year to five years",
          "More than five years"
        ),
        ordered = TRUE
      ),
    decade = glue::glue("{(lubridate::year(date) %/% 10 ) * 10}'s")
  )

plot_df <- plot_df %>%
  left_join(
    plot_df %>%
      group_by(decade) %>%
      tally(),
    by = "decade"
  ) %>%
  mutate(
    decade_lbl = factor(glue::glue("{decade} (N: {n})"))
  )

median_times <- plot_df %>%
  group_by(decade_lbl) %>%
  summarise(
    median_time = median(time)
  )


p1 <- ggplot(plot_df, aes(y = duration_grp)) +
  geom_bar(aes(fill = duration_grp), show.legend = FALSE) +
  scale_fill_brewer(palette = "Dark2", type = "qual") +
  facet_wrap(~track) +
  theme_linedraw(base_size = 16) +
  theme(
    strip.text = element_text(size = 18),
    plot.title.position = "plot",
    plot.title = element_text(size = 32),
    plot.subtitle = element_text(size = 24, color = "grey50"),
    plot.caption = element_text(family = "Inconsolata", size = 16),
    plot.margin = unit(rep(.5, 4), "cm")
  ) +
  labs(
    x = "Frequency",
    y = "How long did the record last",
    title = "Mario Kart: the length of time until a record was broken is track dependent",
    subtitle = "Data source: #TidyTuesday 2021-05-25 (Mario Kart records)",
    caption = "@jmcastagnetto, Jesus M. Castagnetto (2021-05-25)"
  )

ggsave(
  plot = p1,
  filename = "2021-05-25_mario-kart-records/duration_record_by_track.png",
  width = 16,
  height = 14
)

p2 <- ggplot(plot_df, aes(y = track, x = time, fill = stat(x))) +
  stat_density_ridges(
    geom = "density_ridges_gradient",
    quantile_lines = TRUE,
    quantiles = c(.5),
    show.legend = FALSE
  ) +
  scale_fill_viridis_c(direction = -1) +
  facet_wrap(~decade_lbl, scales = "free_y") +
  theme_ridges(font_size = 18) +
  theme(
    strip.background = element_rect(fill = NA),
    strip.text = element_text(face = "bold.italic", hjust = 0.8),
    plot.title.position = "plot",
    plot.title = element_text(size = 32),
    plot.subtitle = element_text(size = 24, color = "grey50"),
    plot.caption = element_text(family = "Inconsolata", size = 16),
    plot.margin = unit(rep(.5, 4), "cm")
  ) +
  labs(
    title = "Are \"Mario Kart\" players getting faster in the 2020's?",
    subtitle = "Perhaps, a side-effect of being cooped up in pandemia...",
    caption = "Data source: #TidyTuesday 2021-05-25 (Mario Kart records) // @jmcastagnetto, Jesus M. Castagnetto (2021-05-25)",
    x = "Record time (seconds)",
    y = ""
  )
ggsave(
  plot = p2,
  filename = "2021-05-25_mario-kart-records/record_times_per_decade_track.png",
  width = 16,
  height = 14
)
