library(tidyverse)

load(
  here::here("2020-02-25_measles-vaccination/measles-vaccination.Rdata")
)

ggplot(measles %>% filter(!is.na(mmr)),
       aes(y = fct_reorder(state, mmr, .fun = median, .desc = TRUE),
           x = mmr)) +
  geom_boxplot(outlier.colour = "yellow",
               outlier.size = .5,
               show.legend = FALSE) +
  ggdark::dark_theme_linedraw(20) +
  labs(
    y = "",
    x = "",
    title = "MMR vaccination rates by state",
    subtitle = "#TidyTuesday, 2020-02-25: Measles vaccination",
    caption = "Source: https://github.com/jmcastagnetto/tidytuesday-kludges\n@jmcastagnetto, Jesús M. Castagnetto"
  ) +
  theme(
    plot.title = element_text(size = 30),
    plot.subtitle = element_text(size = 20, face = "italic"),
    plot.caption = element_text(family = "Inconsolata", size = 14),
    plot.margin = unit(rep(1, 4), "cm")
  )

ggsave(
  filename = here::here("2020-02-25_measles-vaccination/boxplot-mmr-state.png"),
  width = 9,
  height = 10
)

ggplot(measles %>% filter(!is.na(overall)),
       aes(y = fct_reorder(state, overall,
                           .fun = median, .desc = TRUE),
           x = overall)) +
  geom_boxplot(outlier.colour = "yellow",
               outlier.size = .5,
               show.legend = FALSE) +
  ggdark::dark_theme_linedraw(20) +
  labs(
    y = "",
    x = "",
    title = "Overall vaccination rates by state",
    subtitle = "#TidyTuesday, 2020-02-25: Measles vaccination",
    caption = "Source: https://github.com/jmcastagnetto/tidytuesday-kludges\n@jmcastagnetto, Jesús M. Castagnetto"
  ) +
  theme(
    plot.title = element_text(size = 30),
    plot.subtitle = element_text(size = 20, face = "italic"),
    plot.caption = element_text(family = "Inconsolata", size = 14),
    plot.margin = unit(rep(1, 4), "cm")
  )

ggsave(
  filename = here::here("2020-02-25_measles-vaccination/boxplot-overall-state.png"),
  width = 9,
  height = 10
)
