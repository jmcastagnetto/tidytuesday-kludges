# -- original plot from Spurious Correlations
# http://tylervigen.com/view_correlation?id=1703
library(tidyverse)
library(cowplot)
library(magick)

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
    year = ifelse(year == 2000,
                  "2000",
                  sprintf("%02d", year %% 2000)) %>%
      fct_inorder(ordered = TRUE)
  )

p1 <- ggplot(df, aes(group = 1, x = year, y = divorce)) +
  geom_line(color = "blue", size = 1) +
  scale_y_continuous(limits = c(3.5, 5.25),
                     breaks = seq(3.5, 5.25, .25)) +
  labs(
    x = "",
    y = "Divorce rate\nin Maine per\n1000 people"
  ) +
  theme_minimal() +
  theme(
    plot.margin = unit(c(1, 0.1, 0.1, 0.1), "cm"),
    panel.grid = element_blank(),
    panel.grid.major.x = element_line(color = "darkgrey"),
    axis.line = element_line(color = "darkgrey"),
    axis.title.y = element_text(vjust = 1.2,
                                hjust = 1,
                                angle = 0,
                                color = "blue"),
    axis.text.y = element_text(color = "blue",
                               size = 12)
  )

p2 <- ggplot(df, aes(group = 1, x = year, y = margarine)) +
  geom_line(color = "red", size = 1) +
  scale_y_continuous(limits = c(0, 10),
                     breaks = seq(0, 10, 2),
                     position = "right") +
  labs(
    title = "Correlation: 99%",
    x = "",
    y = "Per capita\nconsumption of\nmargarine (lbs)",
    caption = "Source: US Census & USDA, tylervigen.com"
  ) +
  theme_minimal() +
  theme(
    plot.margin = unit(c(1, 0.1, 0.1, 0.1), "cm"),
    panel.border = element_rect(color = "darkgrey", fill = NA),
    panel.grid = element_blank(),
    axis.title.y.right = element_text(vjust = 1.2,
                                      hjust = 0,
                                      angle = 0,
                                      color = "red"),
    axis.text.y = element_text(color = "red",
                               size = 12),
    plot.title = element_text(size = 24, hjust = 0.5),
    plot.caption = element_text(color = "red",
                                size = 12, hjust = -1)
  )

bg_fname <- here::here(
  "2019-12-09_replicating-plots-in-r",
  "bbc_background_plot.jpg")

download.file(
  url = "https://ichef-1.bbci.co.uk/news/1024/cpsprodpb/18663/production/_95493999_p04z8ltw.jpg",
  destfile = bg_fname
)

bg_img <- bg_fname %>%
  image_read() %>%
  image_colorize(35, "white")

aligned_plots <- align_plots(p1, p2, align="hv", axis="tblr")

ggdraw() +
  draw_image(bg_img) +
  draw_plot(aligned_plots[[1]]) +
  draw_plot(aligned_plots[[2]])
