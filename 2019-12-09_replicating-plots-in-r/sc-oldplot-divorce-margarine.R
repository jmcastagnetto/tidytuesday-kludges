# -- original plot from Spurious Correlations
# http://tylervigen.com/view_correlation?id=1703
library(tidyverse)
library(cowplot)
library(ggalt)

# library(dslabs)
# data(divorce_margarine)
# data frame has its last row values switched
# See: https://github.com/rafalab/dslabs/issues/5
divorce_margarine <-
  structure(
    list(
      divorce_rate_maine =
        c(
          0.005, 0.0047, 0.0046, 0.0044, 0.0043,
          0.0041, 0.0042, 0.0042, 0.0042, 0.0041
        ),
      margarine_consumption_per_capita =
        c(8.2, 7, 6.5, 5.3, 5.2,
          4, 4.6, 4.5, 4.2, 3.7),
      year = 2000:2009
    ),
    row.names = c(NA, -10L),
    class = "data.frame"
  )

df <- divorce_margarine %>%
  rename(
    divorce = divorce_rate_maine,
    margarine = margarine_consumption_per_capita
  ) %>%
  mutate(
    divorce = divorce * 1000, # rate per thousand
    year = factor(year)
  )

p1 <- ggplot(df, aes(group = 1, x = year, y = divorce)) +
  geom_point(color = "white") +
  geom_xspline(color = "blue", spline_shape = -.4) +
  scale_y_continuous(limits = c(4, 5),
                     breaks = seq(4, 5, .2)) +
  labs(
    x = "",
    y = "Divorce rate per 1000 people"
  ) +
  ggdark::dark_theme_minimal() +
  theme(
    plot.background = element_rect(color = "black", fill = "black"),
    panel.grid = element_blank(),
    axis.line = element_line(color = "white"),
    axis.ticks.length = unit(.2, "cm"),
    axis.ticks = element_line(color = "white"),
    axis.title = element_text(color = "white"),
    axis.text = element_text(color = "white")
  )

p2 <- ggplot(df, aes(group = 1, x = year, y = margarine)) +
  geom_point(color = "white") +
  geom_xspline(color = "red", spline_shape = -.4) +
  scale_y_continuous(limits = c(3, 9),
                     breaks = 3:9,
                     position = "right") +
  labs(
    x = "",
    y = "Pounds",
    caption = "Correlation: 99%  Sources: US Census & USDA"
  ) +
  theme_minimal() +
  theme(
    panel.border = element_blank(),
    panel.grid = element_blank(),
    axis.ticks.length = unit(.2, "cm"),
    axis.ticks = element_line(color = "white"),
    axis.title = element_text(color = "white"),
    axis.text = element_text(color = "white"),
    plot.caption = element_text(color = "red")
  )

df_dummy <- df %>%
  pivot_longer(
    cols = c(divorce, margarine),
    names_to = "series",
    values_to = "value"
  )

p_dummy <- ggplot(df_dummy,
                  aes(
                    x = year,
                    y = value,
                    group = series,
                    fill = series
                  )) +
  geom_point(shape = 22, size = 3) +
  labs(fill = "") +
  ggdark::dark_theme_minimal() +
  scale_fill_manual(
    values = c("blue", "red"),
    labels = c("Divorce rate in Maine",
               "Per capita consumption of margarine (US)")
  ) +
  guides(fill = guide_legend(nrow = 2)) +
  theme(
    panel.border = element_blank(),
    panel.grid = element_blank(),
    legend.position = "top",
    legend.justification = "left",
    legend.box.background = element_rect(fill = "black"),
    legend.text = element_text(color = "white")
  )

legend <- get_legend(p_dummy)

aligned_plots <- align_plots(p1, p2, align="hv", axis="tblr")
ap <- ggdraw(aligned_plots[[1]]) +
  draw_plot(aligned_plots[[2]]) +
  coord_fixed(ratio = .3) +
  panel_border(color = "black", remove = TRUE) +
  theme(
    plot.background = element_rect(fill = "black", color = "black")
  )

gtext_top <- ggdraw() +
  draw_text(
    text = c(
      "Divorce rate in Maine",
      "correlates with",
      "Per capita consumption of margarine (US)"
      ),
    size = c(
      28, 14, 28
      ),
    color = c(
      "blue", "black", "blue"
    ),
    y = c(.8, .6, .4),
    x = c(.5, .5, .5)
  ) +
  theme(
    panel.border = element_blank(),
    plot.background = element_rect(fill = "#e6e6e6"),
    plot.margin = unit(rep(0, 4), "cm")
  )

gtext_bottom <- ggdraw() +
  draw_text(
    text = c(
      "#TidyTuesday 2019-12-10: Replicating plots in R",
      "The original plot is at http://tylervigen.com/view_correlation?id=1703",
      "@jmcastagnetto, Jesús M. Castagnetto"
    ),
    size = c(
      12, 12, 10
    ),
    color = "black",
    y = c(.8, .6, .4),
    x = .95,
    hjust = 1
  ) +
  theme(
    panel.border = element_blank(),
    plot.background = element_rect(fill = "#e6e6e6"),
    plot.margin = unit(rep(0, 4), "cm")
  )

sc_plot1 <- plot_grid(gtext_top, legend, ap, gtext_bottom,
          rel_heights = c(.5, .3, 1.5, .5), nrow = 4) +
  theme(
    plot.background = element_rect(fill = "black")
  )

sc_plot1
