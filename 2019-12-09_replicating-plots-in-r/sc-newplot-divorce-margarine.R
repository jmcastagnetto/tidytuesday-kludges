# -- New version of a plot from Spurious Correlations,
# https://www.tylervigen.com/spurious-correlations
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
    year = factor(year, ordered = TRUE)
  )

p1 <- ggplot(df, aes(group = 1, x = year, y = divorce)) +
  geom_point(fill = "red", shape = 22, size = 2) +
  geom_xspline(color = "red", size = 1) +
  scale_x_discrete(
    position = "top"
  ) +
  scale_y_continuous(
    limits = c(3.96, 5.0),
    breaks = seq(3.96, 4.95, .33),
    labels = function(x) {
        sprintf("%.2f per 1,000", x)
      }
  ) +
  labs(
    x = "",
    y = "Divorce rate in Maine"
  ) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.text.x = element_text(size = 12, color = "red"),
    axis.line.x = element_line(color = "darkgrey"),
    axis.title.y = element_text(color = "red", size = 18),
    axis.ticks.x = element_line(),
    axis.text.y = element_text(color = "red",
                               size = 12)
  )

p2 <- ggplot(df, aes(group = 1, x = year, y = margarine)) +
  geom_point(fill = "black", shape = 21, size = 2) +
  geom_xspline(color = "black", size = 1) +
  scale_y_continuous(
    limits = c(2, 9),
    breaks = seq(2, 8, 2),
    labels = function(x) {
      sprintf("%dlbs", x)
    },
    position = "right"
  ) +
  labs(
    x = "",
    y = "Margarine consumed"
  ) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "darkgrey"),
    axis.text.x = element_text(size = 12),
    axis.line.x = element_line(color = "darkgrey"),
    axis.title.y = element_text(color = "black", size = 18),
    axis.ticks.x = element_line(),
    axis.text.y = element_text(color = "black",
                               size = 12)
  )
# to extract the legend
df_dummy <- df %>%
  pivot_longer(
    cols = c(divorce, margarine),
    names_to = "series",
    values_to = "value"
  ) %>%
  mutate(
    shape = ifelse(series == "divorce", 22, 21)
  )

p_dummy <- ggplot(df_dummy,
                  aes(
                    x = year,
                    y = value,
                    group = series,
                    color = series,
                    fill = series
                  )) +
  geom_point(shape = df_dummy$shape, size = 3) +
  geom_line(size = 1) +
  labs(fill = "") +
  theme_minimal() +
  scale_color_manual(
    name = "",
    values = c("black", "red"),
    labels = c("Margarine consumed",
               "Divorce rate in Maine"),
    aesthetics = c("color", "fill")
  ) +
  theme(
    panel.border = element_blank(),
    panel.grid = element_blank(),
    legend.position = "bottom",
    legend.text = element_text(size = 12),
  )

legend <- get_legend(p_dummy)

gtext_top <- ggdraw() +
  draw_text(
    text = c(
      "Divorce rate in Maine",
      "correlates with",
      "Per capita consumption of margarine (US)"
    ),
    size = c(
      28, 18, 28
    ),
    color = c(
      "red", "darkgrey", "black"
    ),
    family = "serif",
    y = c(.8, .6, .4),
    x = c(.5, .5, .5)
  ) +
  theme(
    panel.border = element_blank(),
    plot.background = element_rect(fill = "#e6e6e6"),
    plot.margin = unit(rep(0, 4), "cm")
  ) +
  panel_border(color = "white", size = 0, remove = TRUE)

gtext_bottom <- ggdraw() +
  draw_text(
    text = c(
      "#TidyTuesday 2019-12-10: Replicating plots in R",
      "The original plot is at https://www.tylervigen.com/spurious-correlations",
      "@jmcastagnetto, Jesús M. Castagnetto"
    ),
    size = c(
      10, 10, 10
    ),
    color = "black",
    y = c(.8, .6, .4),
    x = .95,
    hjust = 1
  ) +
  theme(
    panel.border = element_blank(),
    plot.background = element_rect(fill = "white"),
    plot.margin = unit(rep(0, 4), "cm")
  )


gtext_caption <- ggdraw() +
  draw_text(
    text = "Data sources: National Vital Statistics Reports and U.S. Deparment of Agriculture",
    color = "gray",
    size = 11,
    x = 0.02,
    hjust = 0
  )

aligned_plots <- align_plots(p1, p2, align="hv", axis="tblr")

scnew_plot <- ggdraw() +
  draw_plot(aligned_plots[[1]]) +
  draw_plot(aligned_plots[[2]])

plot_grid(
  gtext_top, scnew_plot, legend, gtext_caption, gtext_bottom,
  rel_heights = c(.5, 1.5, .3, .3, .3),
  rel_widths = rep(1, 5),
  ncol = 1
)
