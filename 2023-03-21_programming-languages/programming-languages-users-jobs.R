library(tidyverse)

langs <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-03-21/languages.csv')

pl_df <- langs %>%
  filter(type == "pl" &
           !is.na(number_of_users) &
           !is.na(number_of_jobs)) %>%
  mutate(
    decade = appeared - (appeared %% 10),
    decade = as.factor(decade)
  )

p1 <- ggplot(pl_df %>% filter(number_of_users > 1e5),
       aes(x = number_of_users, y = number_of_jobs)) +
  geom_point(aes(color = decade), size = 8) +
  geom_smooth(method = "lm", formula = y~x, linewidth = 2, alpha = .5) +
  ggrepel::geom_text_repel(
    data = pl2 %>% filter(number_of_users > 2e6),
    aes(label = glue::glue("{title}\n({appeared})")),
    arrow = arrow(length = unit(3, "mm"), type = "closed"),
    point.padding = unit(1, "lines"),
    box.padding = unit(2, "lines"),
    max.overlaps = 20,
    family = "Atkinson Hyperlegible",
    fontface = "bold",
    size = 9,
    seed = 20230321
  ) +
  annotate(
    geom = "text_box",
    label = "Considering programming languages with 100,000 users of more, there is a nice linear relation between *number of users* and *number of jobs*. The most popular languages (more than 2 million users) are from the 70s, 80s, and 90s, which makes sense, as it takes time for a programming language to accrue a good number of users and gain general acceptance in the job market.",
    width = unit(30, "cm"),
    box.size = 0,
    x = 0,
    y = 1e5,
    hjust = 0,
    vjust = 1,
    fill = NA,
    family = "Atkinson Hyperlegible",
    size = 10
  ) +
  labs(
    x = "Users",
    y = "Jobs",
    color = "Decade",
    caption = "#TidyTuesday 2023-03-21 // @jmcastagnetto@mastodon.social, Jesus Castagnetto"
  ) +
  scale_x_continuous(labels = scales::comma) +
  scale_y_continuous(labels = scales::comma) +
  scale_color_manual(values = palette("Okabe-Ito")) +
  theme_classic(base_family = "Atkinson Hyperlegible", base_size = 28) +
  guides(
    color = guide_legend(ncol = 2)
  ) +
  theme(
    axis.title = element_text(hjust = 1, size = 42),
    legend.position = c(.75, .25),
    legend.key.height = unit(1.5, "cm"),
    plot.caption = element_text(family = "Inconsolata")
  )

ggsave(
  plot = p1,
  filename = "2023-03-21_programming-languages/proglang-users-jobs-chart.png",
  width = 24,
  height = 10
)
