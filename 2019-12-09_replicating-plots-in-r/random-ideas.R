# -- original plot from Spurious Correlations

library(tidyverse)
library(dslabs)

data("divorce_margarine")
df <- divorce_margarine %>%
  rename(
    divorce = divorce_rate_maine,
    margarine = margarine_consumption_per_capita
  ) %>%
  mutate(
    divorce = divorce * 1000, # rate per thousand
    year = factor(year)
  )

# looks like the last point of the dataset is reversed

f <- function(x) {
  c = 1.3 / 4.2
  c * x
}

p1 <- ggplot(df, aes(group = 1, x = year, y = margarine)) +
  geom_point(color = "gray") +
  geom_smooth(
    method = "lm",
    formula = y ~ poly(x, 9),
    se = FALSE,
    color = "gray"
  ) +
  scale_y_continuous(limits = c(3, 9), position = "right") +
  theme_minimal() +
  theme(
    panel.grid = element_blank()
  )

p2 <- ggplot(df, aes(group = 1, x = year, y = divorce)) +
  geom_point(color = "blue") +
  geom_smooth(
    method = "lm",
    formula = y ~ poly(x, 8),
    se = FALSE,
    color = "blue"
  ) +
  scale_y_continuous(limits = c(4, 5)) +
  theme_minimal() +
  theme(
    panel.grid = element_blank()
  )

library(cowplot)

aligned_plots <- align_plots(p1, p2, align="hv", axis="tblr")
ggdraw(aligned_plots[[1]]) +
  draw_plot(aligned_plots[[2]])
