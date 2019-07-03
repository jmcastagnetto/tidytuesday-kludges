library(tidyverse)

# get the data
media_franchises <- read_csv(
  "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-07-02/media_franchises.csv",
  col_types = "ccdiccc"
)

# store it locally
save(
  media_franchises,
  file = here::here("2019-07-02_media-franchises/data/media_franchises.Rdata")
)

# prepare it for plotting
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
  select(-total_revenue)

# simple comparison plot
ggplot(df, aes(x = decade, y = pct_revenue, fill = revenue_category)) +
  geom_col() +
  scale_fill_viridis_d(name = "Revenue\nCategory", option = "inferno") +
  scale_y_continuous(labels = scales::percent) +
  scale_x_discrete(limits = rev(levels(df$decade))) +
  labs(
    x = "",
    y = "",
    title = "Share of revenue per category over the decades",
    subtitle = "#tidytuesday: 'Media Franchises' (2019-07-02)",
    caption = "Jesus Castagnetto (@jmcastagnetto), 2019"
  ) +
  #theme_minimal() +
  ggthemes::theme_clean() +
  theme(
    legend.position = "bottom",
    legend.text = element_text(size = 7),
    legend.title = element_text(size = 7),
    legend.background = element_blank(),
    plot.background = element_blank(),
    plot.caption = element_text(face = "italic",
                                size = 8,
                                color = "grey30"
                          )
  ) +
  guides (
     fill = guide_legend(nrow = 3, byrow = TRUE)
  ) +
  coord_flip()

# save the plot
ggsave(
  here::here(
    "2019-07-02_media-franchises",
    "20190702-tidytuesday-media-franchises-category-decades.png"
  )
)


