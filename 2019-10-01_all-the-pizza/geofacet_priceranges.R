library(tidyverse)
library(geofacet)

load(
  here::here("2019-10-01_all-the-pizza/all_the_piza.Rdata")
)

summ_state <- pizza_locations %>%
  filter(!is.na(state)) %>%
  mutate(
    price_range = case_when(
      price_range == "up to 25" ~ "😄",
      price_range == "more than 25" ~ "😞️️",
      TRUE ~ "🤔"
    )
  ) %>%
  group_by(state, price_range) %>%
  tally() %>%
  ungroup() %>%
  group_by(state) %>%
  mutate(
    pct = n / sum(n, na.rm = TRUE)
  )

ggplot(summ_state, aes(x = price_range, y = pct,                     fill = price_range)) +
  geom_col(show.legend = FALSE) +
  labs(
    title = "Distribution of price ranges for geolocated 🍕 shops",
    subtitle = "#TidyTuesday, 'All the pizza' dataset, 2019-10-01 (😄: ≤ USD 25, 😞: > USD 25, 🤔: Unknown)",
    caption = "@jmcastagnetto, Jesus M. Castagnetto",
    x = "",
    y = ""
  ) +
  coord_polar() +
  facet_gscale_fill_manual(values = colorblindr::palette_OkabeIto) +
  eo(~state) +
  theme_minimal() +
  theme(
    axis.text.y = element_blank(),
    strip.background = element_rect(fill = "grey80", color = "grey80"),
    plot.margin = unit(rep(1, 4), "cm"),
    plot.title = element_text(size = 24),
    plot.captionsubtitle = element_text(size = 16),
    plot. = element_text()
  )

family = "fixed", size = 12