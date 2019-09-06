library(tidyverse)
library(ggdark)
library(ggstatsplot)
library(lemon)

cpu <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-03/cpu.csv") %>%
  mutate(
    decade = (date_of_introduction - (date_of_introduction %% 10))
  )

gpu <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-03/gpu.csv") %>%
  mutate(
    decade = (date_of_introduction - (date_of_introduction %% 10))
  )

ram <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-03/ram.csv") %>%
  mutate(
    decade = (date_of_introduction - (date_of_introduction %% 10))
  )

save(
  cpu, gpu, ram,
  file = here::here("2019-09-03_moores-law/moores-law.Rdata")
)

load(
  here::here("2019-09-03_moores-law/moores-law.Rdata")
)

library(ggpirate)

cpu <- cpu %>%
  mutate(
    decade = as.factor(decade),
    log_count = log10(transistor_count)
  )



library(ggalt)


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
  coord_flex_cart(
     bottom = brackets_horizontal()
  ) +
  theme(
    legend.position = "none",
    panel.border = element_blank(),
    axis.line = element_line(),
    plot.margin = unit(rep(1, 4), "cm")
  )

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

library(ggpmisc)

p2 <- ggplot(dblldf, aes(x = drange)) +
  geom_point(aes(y = m), color = "white") +
  geom_point(aes(y = m1), color = "white") +
  geom_linerange(aes(ymin = m, ymax = m1), color = "white") +
  geom_text(aes(y = (m1 - m)/2,
                label = sprintf("%.1e", (m1 - m))),
            nudge_x = 0.3,
            color = "white",
            size = 3)+
  annotate(
    "text", x = 1.5, y = 1.5e+8,
    label = "Difference in median\ntransistor counts\nbetween decades"
  ) +
  scale_y_log10() +
  annotation_logticks(sides = "l", color = "white") +
  labs(
    x = "",
    y = ""
  ) +
  dark_theme_minimal() +
  theme(
    legend.position = "none",
    panel.border = element_blank(),
    panel.background = element_blank(),
    axis.line = element_blank()
  )

library(cowplot)

ggdraw(p1) +
  draw_plot(p2, .1, .6, .4, .3)

p1 +
  geom_plot_npc(aes(npcx = 1, npcy = 0, label = "plot"))


ggbetweenstats(
  data = cpu,
  x = decade,
  y = transistor_count,
  messages = FALSE,
  results.subtitle = FALSE
) +
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
  coord_flex_cart(
    bottom = brackets_horizontal()
  ) +
  geom_segment(medians, aes(x = 0, xend = decade,
                            y = m, yend = m)) +
  theme(
    legend.position = "none",
    panel.border = element_blank(),
    axis.line = element_line(),
    plot.margin = unit(rep(1, 4), "cm")
  )


ggplot(cpu, aes(x = date_of_introduction, y = transistor_count/area)) +
  geom_point() +
  scale_y_log10() +
  geom_smooth(method = "glm")

cpu_m1 <- lm(log10(transistor_count) ~ date_of_introduction, cpu)

cpu_pred <- predict(cpu_m1, cpu)

plot(log10(cpu$transistor_count), (cpu_pred))


cpu_df <- cpu %>%
  mutate(
    log10_count = log10(transistor_count)
  )

cpu_m1 <- lm(log10_count ~ date_of_introduction, cpu_df)
cpu_df$log10_pred <- predict(cpu_m1, cpu_df)

source("common/my_style.R")
source("common/build_plot.R")

ggplot(cpu_df, aes(x = log10_count, y = log10_pred)) +
  geom_point(aes(color = designer), show.legend = FALSE) +
  geom_smooth(method = "lm", show.legend = FALSE) +
  coord_fixed() +
  labs(
    x = "Transistor count",
    y = "Predicted count"
  ) +
  annotation_logticks() +
  jmcastagnetto_style()

