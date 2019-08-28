library(tidyverse)
library(ggthemes)
library(ggrepel)

source("common/my_style.R")
source("common/build_plot.R")

load(
  here::here("2019-08-27_simpsons-guests/simpsons-guests.Rdata")
)

movie <- simpsons %>%
  filter(
    number == "M1"
  )

shows <- simpsons %>%
  filter(
    number != "M1"
  ) %>%
  mutate(
    season = forcats::as_factor(season)
  )

guests_episode <- shows %>%
  group_by(season, episode_title) %>%
  summarise(
    n_guests = n_distinct(guest_star)
  ) %>%
  mutate(
    label = ifelse(n_guests >= 10,
                   glue::glue("{episode}: {n} guests",
                              episode=episode_title, n=n_guests),
                   "")
  )

p1 <- ggplot(guests_episode, aes(x = season, y = n_guests, color = season)) +
  geom_tufteboxplot(
    size = 1,
    show.legend = FALSE) +
  geom_jitter(width = 0.1, height = 0.05, alpha = 0.5, shape = 20, show.legend = FALSE) +
  labs(
    title = "Distribution of the number of guests per season",
    subtitle = "#TidyTuesday, Simpson's guests data set, 2019-08-27",
    x = "Season",
    y = ""
  ) +
  annotate("point", x = 28, y = 13, color = "black", size = 5, stroke = 2, shape = 21) +
  geom_text_repel(aes(label = label), direction = "both",
                  nudge_x = -1, show.legend = FALSE) +
  coord_flip() +
  jmcastagnetto_style()

pf1 <- build_plot(p1)
pf1

ggsave(
  here::here("2019-08-27_simpsons-guests/tufte-boxplot.png"),
  plot = pf1,
  width = 9,
  height = 12
)
