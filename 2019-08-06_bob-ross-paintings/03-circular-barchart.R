# adapted from https://www.r-graph-gallery.com/circular-barplot.html

library(fivethirtyeight)
library(tidyverse)
library(cowplot)

data("bob_ross")

br_elements <- bob_ross %>%
  janitor::clean_names() %>%
  separate(episode, into = c("season", "episode"), sep = "E") %>%
  mutate(season = str_extract(season, "[:digit:]+")) %>%
  mutate_at(vars(season, episode), as.integer) %>%
  select(-episode_num) %>%
  select(-episode, -title, -season) %>%
  pivot_longer(
    cols = apple_frame:wood_framed,
    names_to = "element",
    values_to = "freq"
  ) %>%
  group_by(element) %>%
  summarise(
    freq = sum(freq)
  ) %>%
  ungroup(element) %>%
  mutate(
    element = ifelse(freq < 5, "** Other", element) %>%
      str_replace_all("_", " ") %>%
      str_to_title()
  ) %>%
  group_by(element) %>%
  summarise(
    freq = sum(freq)
  ) %>%
  ungroup() %>%
  mutate(
    element = paste0(element,"\n(N = ", freq, ")") %>%
              forcats::fct_reorder(freq)
  )

br_elements$id <- seq(1, nrow(br_elements))
angle <-  90 - (360 * (br_elements$id - 0.5) / nrow(br_elements))
br_elements$hjust <- as.numeric(angle < -90)
br_elements$angle <- angle

cb <- ggplot(br_elements,
       aes(x = element, y = freq)) +
  geom_segment(aes(x = element, xend = element,
                   y = 0, yend = 375),
               color = "lightgrey", size = .25,
               linetype = "dashed") +
  geom_col(aes(fill = element), width = 1) +
  labs(
    x = "",
    y = "",
    title = "Frequency of elements in Bob Ross's paintings",
    subtitle = "#tidytuesday, 2019-08-06\nelements with a total frequency < 5 are categorized as '** Other'\nbar height in log10 scale",
    caption = "@jmcastagnetto (Jesus M. Castagnetto)"
  ) +
  scale_fill_viridis_d(option = "vidiris") +
  scale_y_log10() + # no reason, except that it looks nicer and colorful
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.text.y = element_blank(),
    axis.text.x = element_text(angle = br_elements$angle, size = 9),
    axis.title = element_blank(),
    panel.grid = element_blank(),
  ) +
  coord_polar(start = 0)

ggsave(
  filename = here::here("2019-08-06_bob-ross-paintings/circular-barchart-elements.png"),
  plot = cb,
  width = 12,
  height = 12
)
