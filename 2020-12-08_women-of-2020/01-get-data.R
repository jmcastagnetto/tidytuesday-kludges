library(tidyverse)
library(countrycode)

women <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-12-08/women.csv') %>%
  mutate(
    tmp = case_when(
      country == "Northern Ireland" ~ "UK",
      country == "Wales, UK" ~ "UK",
      country == "Exiled Uighur from Ghulja (in Chinese, Yining)" ~ "China",
      country == "Somaliland" ~ "Somalia",
      TRUE ~ country
    ),
    iso3c = countryname(tmp, destination = "iso3c"),
    region = countryname(tmp, destination = "region") %>%
      str_wrap(12),
    region = factor(
      region,
      levels = c(
        "Latin\nAmerica &\nCaribbean",
        "North\nAmerica",
        "Middle East\n& North\nAfrica",
        "Sub-Saharan\nAfrica",
        "Europe &\nCentral Asia",
        "East Asia &\nPacific",
        "South Asia"
      ),
      ordered = TRUE
    ),
    flag = countryname(tmp, destination = "unicode.symbol")
  ) %>%
  select(-tmp)

p1 <- ggplot(women %>% filter(!is.na(iso3c)),
       aes(
         x = region,
         y = category
       )
      ) +
  geom_bin2d(color = "black") +
  ggrepel::geom_text_repel(aes(label = flag),
            size = 9,
            min.segment.length = unit(10, "cm"),
            position = position_jitter(
              width = .15,
              height = .15
            ),
            seed = 1357
          ) +
  scale_fill_viridis_b(
    direction = -1,
    option = "magma",
    name = ""
  ) +
  labs(
    title = "BBC's Women of 2020: Category and Geographical Distribution",
    subtitle = "Source: BBC & #TidyTuesday 2020-12-08",
    caption = "@jmcastagnetto, Jesus M. Castagnetto",
    x = "",
    y = ""
  ) +
  theme_minimal(20) +
  theme(
    panel.grid = element_blank(),
    axis.text.y = element_text(angle = 90, hjust = 0.5),
    legend.position = c(.85, 1.03),
    legend.direction = "horizontal",
    legend.key.width = unit(1.5, "cm")
  )
p1
ggsave(
  plot = p1,
  filename = "2020-12-08_women-of-2020/category-geodist.png",
  width = 18,
  height = 10
)
