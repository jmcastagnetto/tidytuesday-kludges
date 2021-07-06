library(tidyverse)
library(ggridges)
library(colorblindr)
library(ggsankey)
library(ggtrack)

holidays_raw <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-07-06/holidays.csv')

holidays <- holidays_raw %>%
  mutate(
    iso3c = if_else(
      country == "Micronesia",
      "FSM",
      countrycode::countryname(country, destination = "iso3c")
    ),
    continent = countrycode::countrycode(iso3c,
                                         origin = "iso3c",
                                         destination = "continent"),
    month = lubridate::month(date_parsed, label = TRUE),
    from_continent = case_when(
      independence_from == "Ottoman Empire" ~ "Europe,Asia,Africa",
      str_detect(independence_from,
                 "Soviet|Empire of Japan and France|Netherlands and Japan") ~ "Europe,Asia",
      str_detect(independence_from, "Spain|Spanish|Kingdom|Yugoslavia|Germany|Austria|Czechoslovakia|Netherlands|France|Serbia") ~ "Europe",
      str_detect(independence_from, "China|Japan") ~ "Asia",
      str_detect(independence_from, "American|Rio de la Plata|United States") ~ "Americas",
      str_detect(independence_from, "Australia") ~ "Oceania",
      TRUE ~ countrycode::countryname(independence_from, destination = "continent")
    )
  )


plot_df <- holidays %>%
  select(continent, from_continent) %>%
  separate_rows(
    from_continent,
    sep = ","
  ) %>%
  filter(!is.na(from_continent)) %>%
  make_long(continent, from_continent)

p1 <- ggplot(
  plot_df,
  aes(
    x = x,
    next_x = next_x,
    node = node,
    label = node,
    next_node = next_node,
    fill = factor(node)
  )
) +
  geom_sankey(
    flow.alpha = .4,
    width = .4,
  ) +
  geom_sankey_label(
    size = 5,
    color = "black",
    fill = "grey80"
  ) +
  scale_fill_OkabeIto() +
  scale_x_discrete(
    labels = c(
      "continent" = "Countries here, declared independence",
      "from_continent" = "... from countries here"
    )
  ) +
  theme_sankey(base_size = 18) +
  theme(
    legend.position = "none",
    plot.title = element_text(hjust = .5, size = 28),
    plot.subtitle = element_text(color = "grey50", hjust = .5),
    axis.text.x = element_text(size = 16, face = "bold",
                               color = "black")
  ) +
  labs(
    x = "",
    y = "",
    title = "Who declared independence from whom?",
    subtitle = "Source: #TidyTuesday dataset on \"International Independence Days\""
  )

p2 <- ggtrack(
  p1,
  qr_content = "https://github.com/jmcastagnetto/tidytuesday-kludges",
  logo = "common/for-tagline-jmcastagnetto-twitter2.png",
  height_plot = 25,
  height_tracker = 2.5,
  plot.background = element_rect(fill = "gray90", color = "white"),
  plot.margin = margin(0, 1, 0, 1, "cm")
)

ggsave(
  p2,
  filename = "2021-07-06_international-independence-days/who-declared-independence-from-whom.png",
  width = 10,
  height = 12
)
