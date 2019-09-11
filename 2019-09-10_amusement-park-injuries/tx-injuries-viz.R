library(tidyverse)
library(lubridate)
library(gganimate)
library(extrafont)
library(ggdark)
library(ggridges)


load(
  here::here(
    "2019-09-10_amusement-park-injuries/amusement-park-injuries.Rdata"
  )
)

tx_df <- tx_injuries %>%
  filter(!is.na(injury_date)) %>%
  filter(!is.na(gender)) %>%
  mutate(
    month = month(injury_date, label = TRUE),
    year = as.factor(year(injury_date)),
    gender = ifelse(gender == "F", "♀", "♂")
  )

tx_df1 <- tx_df %>%
  group_by(gender, year, month) %>%
  tally()


p1 <- ggplot(tx_df1, aes(x = month, y = n,
                   fill = year)) +
  geom_col(show.legend = FALSE, width = .5) +
  coord_polar(start = 0) +
  scale_fill_discrete("rainbow") +
  labs (
    title = "Number of njuries in amusement parks (Texas, 2013-2017)",
    subtitle = "Year: {closest_state}\n#TidyTuesday, 2019-09-10.",
    caption = "Source: data.world\n@jmcastagnetto - Jesus M. Castagnetto",
    x = "",
    y = ""
  ) +
  facet_wrap(~gender) +
  dark_theme_minimal() +
  theme(
    axis.text.y = element_blank(),
    axis.text.x = element_text(size = 12, color = "yellow"),
    strip.text = element_text(family = "Inconsolata", size = 36, face = "bold"),
    plot.margin = unit(rep(1, 4), "cm"),
    panel.grid = element_line(color = rgb(1, 1, 1, 0.3)),
    plot.title = element_text(size = 24, face = "bold"),
    plot.subtitle = element_text(size = 18, face = "bold.italic"),
    plot.caption = element_text(family = "Inconsolata", size = 14)
  ) +
  transition_states(year)

anim_p1 <- animate(p1, nframes = 100, detail = 3,
                   width = 1200, height = 800)

anim_save(
  here::here("2019-09-10_amusement-park-injuries/tx-injuries-by-gender.gif"),
  animation = anim_p1
)

tx_df2 <- tx_df %>%
  filter(!is.na(age))

p2 <- ggplot(tx_df2,
             aes(y = year, x = age, fill = ..x..)) +
  geom_density_ridges_gradient(
    quantile_lines = TRUE, quantiles = 2,
    jittered_points = TRUE, alpha = 0.5,
    point_size = 0.6, point_color = "black") +
  scale_fill_viridis_c() +
  labs(
    title = "Age Distribution of Amusement Park Injuries in Texas",
    subtitle = "Young men seem to be more injury prone\n(Median value shown as a vertical line)\n#TidyTuesday, 2019-09-10",
    caption = "Source: data.world\n@jmcastagnetto / Jesus M. Castagnetto",
    y = "",
    x = "",
    fill = "Age (yrs)"
  ) +
  xlim(-10, 80) +
  facet_wrap(~gender) +
  dark_theme_minimal() +
  theme(
    legend.position = "bottom",
    legend.text = element_text(size = 10),
    legend.title = element_text(size = 12),
    legend.justification = c(0, 0),
    axis.text.y = element_text(size = 18, color = "yellow"),
    axis.text.x = element_text(size = 12, color = "yellow"),
    strip.text = element_text(family = "Inconsolata", size = 36, face = "bold.italic"),
    plot.margin = unit(rep(1, 4), "cm"),
    plot.title = element_text(size = 24, face = "bold"),
    plot.subtitle = element_text(size = 18, face = "bold"),
    plot.caption = element_text(family = "Inconsolata", size = 14)
  )

ggsave(
  plot = p2,
  filename = here::here("2019-09-10_amusement-park-injuries/tx-injuries-by-age-and-gender.png"),
  width = 12,
  height = 9
)
