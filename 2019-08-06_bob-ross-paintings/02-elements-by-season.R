library(fivethirtyeight)
library(tidyverse)

data("bob_ross")

bob_ross <- bob_ross %>%
  janitor::clean_names() %>%
  separate(episode, into = c("season", "episode"), sep = "E") %>%
  mutate(season = str_extract(season, "[:digit:]+")) %>%
  mutate_at(vars(season, episode), as.integer) %>%
  select(-episode_num)

br_elements <- bob_ross %>%
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
    element = ifelse(freq < 5, "** Other", element)
  ) %>%
  filter(element != "** Other") %>%
  group_by(element) %>%
  summarise(
    freq = sum(freq)
  ) %>%
  arrange(
    element
  )

valid_elements <- br_elements$element

br_elements_season <- bob_ross %>%
  select(-episode, -title) %>%
  group_by(season) %>%
  mutate_at(
    vars(-group_cols()),
    sum
  ) %>%
  distinct() %>%
  pivot_longer(
    cols = c(-1),
    names_to = "element",
    values_to = "freq"
  ) %>%
  mutate(
    element = ifelse(element %in% valid_elements,
                     element, "** Other") %>%
      str_replace_all("_", " ") %>%
      str_to_title() %>%
      forcats::fct_rev()
  )

hm <- ggplot(br_elements_season,
             aes(x = as.factor(season), y = element)) +
  geom_tile(aes(fill = freq)) +
  scale_fill_viridis_c("Frequency", option = "magma", direction = -1) +
  scale_y_discrete(expand = c(0, 0)) +
  scale_x_discrete(expand = c(0, 0)) +
  labs(
    x = "Season",
    y = "",
    title = "Bob Ross was very consistent in the elements he used",
    subtitle = "#tidytuesday, 2019-08-06\nelements with a total frequency < 5 are categorized as '** Other'",
    caption = "@jmcastagnetto (Jesus M. Castagnetto)"
  ) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    legend.position = c(0.2, -0.05),
    legend.direction = "horizontal",
    legend.key.width = unit(1.5, "cm"),
    legend.text = element_text(size = 8),
    plot.margin = unit(rep(1, 4), "cm")
  )
hm
ggsave(
  filename = here::here("2019-08-06_bob-ross-paintings/heatmap-elements.png"),
  plot = hm,
  width = 12,
  height = 12
)
