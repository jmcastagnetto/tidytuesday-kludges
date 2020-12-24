library(tidyverse)

df <- readRDS("2020-10-13_datasaurus-dozen/datasaurus-dozen.rds")

df2 <- df %>%
  pivot_longer(
    c(x, y),
    names_to = "var",
    values_to = "value"
  )

ggplot(df2, aes(x = value, y = dataset, fill = dataset)) +
  geom_density_ridges(show.legend = FALSE) +
  facet_wrap(~var)


p0 <- ggplot(df, aes(x = x, y = y, color = dataset)) +
  #geom_point(show.legend = FALSE, color = "white") +
  geom_density_2d_filled(show.legend = FALSE) +
  xlim(-10, 110) +
  ylim(-10, 110) +
  coord_equal() +
  theme_classic(18)


library(gganimate)

p0 <- ggplot(df2, aes(x = value, color = dataset)) +
  geom_density(show.legend = FALSE) +
  theme_classic(18) +
  facet_wrap(~var)


p0 +
  labs(
    title = "The Datasaurus Dozen: {closest_state}",
    subtitle = "#TidyTuesday 2020-10-13",
    x = "",
    y = ""
  ) +
  transition_states(
    dataset,
    transition_length = 2,
    state_length = 2
  )

# cool!


p0 +
  geom_smooth(method = "lm") +
  facet_wrap(~dataset)


models <- df %>%
  group_by(dataset) %>%
  group_modify(
    ~ broom::augment(lm(y ~ x, data = .))
  )

p0 <- ggplot(models, aes(x = y, color = dataset)) +
  geom_density()

p0 +
  facet_wrap(~dataset)

ggplot(models, aes(x = .resid, color = dataset)) +
  geom_density() +
  facet_wrap(~dataset)

library(ggridges)

ggplot(models, aes(x = .resid, y = dataset)) +
  geom_density_ridges()

ggplot(models, aes(x = x, y = dataset, fill = dataset)) +
  geom_density_ridges(show.legend = FALSE)


library(ggExtra)

p1 <- ggplot(df, aes(x = x, y = y, group = dataset)) +
  geom_point(aes(color = dataset), show.legend = FALSE)
p1
p2 <- ggMarginal(p1, type = "", groupColour = TRUE, groupFill = TRUE)
p2


library(ggpubr)

p3 <- ggscatterhist(
  df,
  x = "x",
  y = "y",
  color = "dataset",
  group = "dataset",
  margin.params = list(fill = "dataset", color = "black", size = 0.2)
)

p3$sp <- p3$sp +
  facet_wrap(~dataset)
p3
