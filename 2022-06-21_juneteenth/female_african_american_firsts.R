library(ggstream)
firsts <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-06-21/firsts.csv")

female_firsts <- firsts %>%
  filter(gender == "Female African American Firsts") %>%
  group_by(year, category) %>%
  tally()

p1 <- ggplot(
  female_firsts,
  aes(
    x = year,
    y = n,
    group = category,
    fill = category
  )
) +
  geom_stream() +
  scale_fill_brewer(palette = "Dark2") +
  guides(
    fill = guide_legend(ncol = 2)
  ) +
  labs(
    x = "",
    y = "",
    fill = "",
    title = "Evolution of the Number of Female African American Firsts",
    subtitle = "Source: #TidyTuesday 2022-06-21",
    caption = "@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  theme_classic() +
  theme(
    axis.line = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    axis.ticks.length.x = unit(.5, "cm"),
    axis.text.x = element_text(size = 14),
    legend.position = c(.25, .8),
    legend.text = element_text(size = 16),
    panel.grid.major.x = element_line(color = "grey80", linetype = "dashed"),
    plot.title = element_text(size = 24, face = "bold"),
    plot.subtitle = element_text(color = "grey50", size = 18),
    plot.caption = element_text(size = 14)
  )

ggsave(
  plot = p1,
  filename = "2022-06-21_juneteenth/female_african_american_firsts.png",
  width = 14,
  height = 8
)
