library(tidyverse)
library(ggpirate)
library(ggdark)
library(lemon)
library(cowplot)

load(
  here::here("2019-09-03_moores-law/moores-law.Rdata")
)

# --- main plot --
cpu <- cpu %>%
  mutate(
    decade = as.factor(decade),
    log_count = log10(transistor_count)
  )

p1 <- ggplot(cpu, aes(x = decade, y = transistor_count)) +
  geom_pirate(aes(color = decade, fill = decade),
              bars_params = list(width = 0.1)) +
  scale_y_log10() +
  annotation_logticks(sides = "l", color = "white") +
  labs(
    title = "CPU transistor count distribution over the decades",
    subtitle = "Moore's Law dataset / #TidyTuesday 2019-09-03 ",
    y = "Transistor count",
    x = "Decade when the CPU was introduced",
    caption = "@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  dark_theme_bw() +
  # coord_flex_cart(
  #    bottom = brackets_horizontal()
  # ) +
  theme(
    legend.position = "none",
    axis.text = element_text(color = "white", size = 12),
    axis.title = element_text(color = "white", size = 14),
    panel.border = element_blank(),
    axis.line = element_blank(),
    plot.margin = unit(rep(1, 4), "cm"),
    plot.title = element_text(size = 20)
  )

# --- inset plot ---
dblldf <- cpu %>%
  group_by(decade) %>%
  summarise(
    m = median(transistor_count, na.rm = TRUE),
  ) %>%
  mutate(
    m1 = lead(m),
    dec2 = lead(decade),
    drange = glue::glue("{d1}-{d2}", d1 = decade, d2 = dec2)
  ) %>%
  filter(
    !is.na(m1)
  )

p2 <- ggplot(dblldf, aes(x = drange)) +
  geom_point(aes(y = m), color = "white") +
  geom_point(aes(y = m1), color = "white") +
  geom_linerange(aes(ymin = m, ymax = m1), color = "white") +
  geom_text(aes(y = (m1 - m)/2,
                label = sprintf("%.1e", (m1 - m))),
            nudge_x = 0.35,
            color = "white",
            size = 3)+
  annotate(
    "text", x = 1, y = 1.5e+8, hjust = 0,
    label = "Difference in median\ntransistor counts\nbetween decades"
  ) +
  scale_y_log10() +
  #annotation_logticks(sides = "l", color = "white") +
  labs(
    x = "",
    y = ""
  ) +
  dark_theme_minimal() +
  theme(
    legend.position = "none",
    panel.border = element_blank(),
    panel.background = element_blank(),
    axis.line = element_blank(),
    axis.text.y = element_blank()
  )

# --- compose plots ---

p12 <- ggdraw(p1) +
  draw_plot(p2, .12, .6, .34, .3)

library(ragg)

ggsave(
  filename = here::here("2019-09-03_moores-law/cpu-decades-plot.png"),
  plot = p12,
  width = 14,
  height = 9,
  device = agg_png,
  res = 300
)
