library(tidyverse)
library(ggpmisc)

load(
  here::here("2019-09-24_school-diversity/school_diversity.Rdata")
)

simpson_d <- function(p) {
  sum(p * (1 - p), na.rm = TRUE)
}

shannon_h <- function(p) {
  -sum(p * log(p), na.rm = TRUE)
}

shannon_e <- function(p, n) {
  shannon_h(p) / log(n)
}


df2 <-  school_diversity %>%
  rowwise() %>%
  mutate(
    simpson_index = simpson_d(c(aian, asian, black,
                                hispanic, white, multi)/100),
    shannon_index = shannon_e(p = c(aian, asian, black,
                                 hispanic, white, multi)/100,
                              n = 6)
  )

# -- Simpson's D

simpson_df <- df2 %>%
  select(leaid, st, reg, school_year, simpson_index) %>%
  pivot_wider(
    id_cols = c(leaid, st, reg),
    names_from = school_year,
    names_prefix = "sy_",
    values_from = simpson_index
  )

ggplot(simpson_df,
       aes(x = `sy_1994-1995`, y = `sy_2016-2017`)) +
  geom_rect(aes(xmin = 0, xmax = 0.5, ymin = 0, ymax =0.5),
            fill = "red", alpha = 0.5) +
  geom_rect(aes(xmin = 0, xmax = 0.5, ymin = 0.5, ymax = 1),
            fill = "green", alpha = 0.5) +
  geom_rect(aes(xmin = 0.5, xmax = 1, ymin = 0, ymax = 0.5),
            fill = "darkgrey", alpha = 0.5) +
  geom_rect(aes(xmin = 0.5, xmax = 1, ymin = 0.5, ymax = 1),
            fill = "peru", alpha = 0.5) +
  geom_count(color = "yellow", alpha = 0.5,
             show.legend = FALSE) +
  geom_quadrant_lines(xintercept = 0.5, yintercept = 0.5) +
  stat_quadrant_counts(xintercept = 0.5, yintercept = 0.5,
                       quadrants = 1:4, size = 8,
                       show.legend = FALSE, color = "blue") +
  scale_y_continuous(labels = scales::percent_format(1)) +
  scale_x_continuous(labels = scales::percent_format(1)) +
  expand_limits(x = c(0, 1), y = c(0, 1)) +
  labs(
    x = "Diversity Index (1994-1995)",
    y = "Diversity Index (2016-2017)",
    title = "Changes in the Simpson Diversity Index (D) for USA School Districts",
    subtitle = bquote(
      "#TidyTuesday, dataset: 2019-09-24 —" ~ D == sum(p[i] *(1 - p[i]))
    ),
    caption = "Source: NCES via Washington Post\n@jmacastagnetto, Jesus M. Castagnetto"
  ) +
  facet_wrap(~reg) +
  theme_light() +
  theme(
    plot.margin = unit(rep(1, 4), "cm"),
    plot.title = element_text(size = 24),
    plot.subtitle = element_text(family = "fixed", size = 14),
    plot.caption = element_text(family = "fixed", size = 12),
    strip.text = element_text(face = "bold", size = 12),
    axis.title = element_text(size = 14)
  )

# -- Shannon's E

shannon_df <- df2 %>%
  select(leaid, st, reg, school_year, shannon_index) %>%
  pivot_wider(
    id_cols = c(leaid, st, reg),
    names_from = school_year,
    names_prefix = "sy_",
    values_from = shannon_index
  )

ggplot(shannon_df,
       aes(x = `sy_1994-1995`, y = `sy_2016-2017`)) +
  geom_rect(aes(xmin = 0, xmax = 0.5, ymin = 0, ymax =0.5),
            fill = "red", alpha = 0.5) +
  geom_rect(aes(xmin = 0, xmax = 0.5, ymin = 0.5, ymax = 1),
            fill = "green", alpha = 0.5) +
  geom_rect(aes(xmin = 0.5, xmax = 1, ymin = 0, ymax = 0.5),
            fill = "darkgrey", alpha = 0.5) +
  geom_rect(aes(xmin = 0.5, xmax = 1, ymin = 0.5, ymax = 1),
            fill = "peru", alpha = 0.5) +
  geom_count(color = "yellow", alpha = 0.7,
             show.legend = FALSE) +
  geom_quadrant_lines(xintercept = 0.5, yintercept = 0.5) +
  stat_quadrant_counts(xintercept = 0.5, yintercept = 0.5,
                       quadrants = 1:4, size = 8,
                       show.legend = FALSE, color = "blue") +
  expand_limits(x = c(0, 1), y = c(0, 1)) +
  labs(
    x = "Equitability Index (1994-1995)",
    y = "Equitability Index (2016-2017)",
    title = bquote(
      "Changes in the Shannon Equitability Index (" ~ E[H] ~ ")  for USA School Districts"
      ),
    subtitle = bquote(
      "#TidyTuesday, dataset: 2019-09-24 —" ~ E[H] == (-sum(p[i] * ln(p[i]))) / ln(S) ~ "\nwhere: " ~ E[H] == 1 ~ "means an even distribution of ethnicities."
      ),
    caption = "Source: NCES via Washington Post\n@jmacastagnetto, Jesus M. Castagnetto"
    ) +
  facet_wrap(~reg) +
  theme_light() +
  theme(
    plot.margin = unit(rep(1, 4), "cm"),
    plot.title = element_text(size = 24),
    plot.subtitle = element_text(family = "fixed", size = 14),
    plot.caption = element_text(family = "fixed", size = 12),
    strip.text = element_text(face = "bold", size = 12),
    axis.title = element_text(size = 14)
  )
