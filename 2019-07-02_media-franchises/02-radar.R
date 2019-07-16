library(tidyverse)
library(gganimate)
library(ggiraph)
library(ggiraphExtra)

load(here::here("2019-07-02_media-franchises/data/media_franchises.Rdata"))

df <- media_franchises %>%
  mutate(
    decade = as.factor((year_created %/% 10) * 10)
  ) %>%
  group_by(decade, revenue_category) %>%
  summarise(
    total_revenue = sum(revenue)
  ) %>%
  ungroup() %>%
  group_by(decade) %>%
  mutate(
    pct_revenue = total_revenue / sum(total_revenue)
  ) %>%
  ungroup() %>%
  select(-total_revenue) %>%
  pivot_wider(
    id_cols = decade,
    names_from = revenue_category,
    values_from = pct_revenue,
    values_fill = list(pct_revenue = 0)
  )

#
# df %>%
#   group_by(decade) %>%

a <- ggRadar(data = df, mapping = aes(color = decade),
        rescale = FALSE, interactive = FALSE,
        legend.position = "bottom") +
  theme_minimal() +
  scale_y_continuous(labels = scales::percent) +
  theme(
    axis.text.x = element_text(size = 10),
    legend.position = "none"
  ) +
  labs(
    title = "Decade: {closest_state}"
  ) +
  transition_states(decade) +
  ease_aes("linear")

a

library(GGally)

ggparcoord(df, 2:ncol(data), groupColumn = "decade") +
  coord_flip()

ggparallel(data = df)

b <- ggradar(df)

b +
  transition_states(decade)



, mapping = aes(facet = decade), )


p <- ggradar()

p +
  facet_wrap(~decade, ncol = 3)
