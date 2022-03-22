library(tidyverse)

usanames <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-03-22/babynames.csv")
nznames <- read_csv("https://github.com/rfordatascience/tidytuesday/raw/master/data/2022/2022-03-22/nz_names.csv")

n1 <- usanames %>%
  filter(year >= 1900) %>%
  arrange(year, sex, desc(n)) %>%
  rename(
    n_usa = n
  ) %>%
  select(-prop) %>%
  group_by(year, sex) %>%
  top_n(100, n_usa) %>%
  mutate(
    sex = if_else(
      sex == "F",
      "Female",
      "Male"
    )
  )

n2 <- nznames %>%
  janitor::clean_names() %>%
  filter(year <= 2017) %>%
  arrange(year, sex, desc(count)) %>%
  rename(
    n_nz = count
  ) %>%
  group_by(year, sex) %>%
  top_n(100, n_nz)

plot_df <- n2 %>%
  inner_join(
    n1,
    by = c("year", "sex", "name")
  ) %>%
  arrange(year, sex, n_nz) %>%
  group_by(year, sex) %>%
  mutate(
    rank_nz = rank(-n_nz, ties.method = "min")
  ) %>%
  arrange(year, sex, n_usa) %>%
  group_by(year, sex) %>%
  mutate(
    rank_usa = rank(-n_usa, ties.method = "min")
  ) %>%
  ungroup() %>%
  arrange(year, sex, rank_nz, rank_usa) %>%
  group_by(year, sex) %>%
  tally() %>%
  mutate(
    sex = paste(sex, "names")
  )

p1 <- ggplot(plot_df, aes(x = year, y = n / 100, color = sex)) +
  geom_step(size = 1, show.legend = FALSE, direction = "hv") +
  scale_y_continuous(
    labels = scales::percent,
    n.breaks = 6
  ) +
  scale_color_manual(
    values = c("Female names" = "darkorange", "Male names" = "darkblue")
  ) +
  labs(
    y = "Fraction of coincident names",
    x = "",
    title = "Concidences between the top 100 baby names in New Zealand and USA",
    subtitle = "#TidyTuesday (2022-03-22): \"Baby names\" dataset  - From 1900 to 2017",
    caption = "@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  facet_wrap(~sex) +
  ggthemes::theme_tufte(18) +
  theme(
    axis.title.y = element_text(hjust = 1),
    plot.title.position = "plot",
    plot.title = element_text(size = 26),
    plot.subtitle = element_text(size = 20, color = "grey40"),
    plot.caption = element_text(family = "Inconsolata", size = 14),
    strip.text = element_text(face = "bold.italic", size = 20),
    panel.spacing = unit(2, "lines"),
    plot.background = element_rect(fill = "white")
  )
p1

ggsave(
  p1,
  filename = "2022-03-22_baby-names/coincidences-top100-names-nz-usa.png",
  width = 14,
  height = 8
)
