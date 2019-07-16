library(tidyverse)
library(gganimate)
library(ggiraph)
library(ggiraphExtra)

load(here::here("2019-07-02_media-franchises/data/media_franchises.Rdata"))

df <- media_franchises %>%
  mutate(
    Decade = as.factor((year_created %/% 10) * 10)
  ) %>%
  group_by(Decade, revenue_category) %>%
  summarise(
    total_revenue = sum(revenue)
  ) %>%
  ungroup() %>%
  group_by(Decade) %>%
  mutate(
    pct_revenue = total_revenue / sum(total_revenue)
  ) %>%
  select(-total_revenue) %>%
  pivot_wider(
    id_cols = Decade,
    names_from = revenue_category,
    values_from = pct_revenue,
    values_fill = list(pct_revenue = 0)
  )

radar_chart <- ggRadar(data = df,
       mapping = aes(
         color = Decade),
       interactive = FALSE, horizontal = TRUE,
       size = 1) +
  theme_minimal() +
  scale_y_continuous(labels = scales::percent) +
  theme(
    axis.text.x = element_text(size = 10),
    legend.position = "none"
  ) +
  labs(
    title = "Change in revenue distribution for media franchises",
    subtitle = "Decade: {closest_state}",
    caption = "@jmcastagnetto (Jesus M. Castagnetto)"
  ) +
  transition_states(Decade) +
  ease_aes("linear")

radar_chart

anim_save(
  filename  = here::here("2019-07-02_media-franchises/radar-chart.gif"),
  animation = radar_chart
)
