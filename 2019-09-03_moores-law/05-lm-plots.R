library(tidyverse)
library(ggpmisc)
library(ggdark)
library(ragg)


load(
  here::here("2019-09-03_moores-law/moores-law.Rdata")
)

# plot linear models for cpu, gpu and ram

df <- bind_rows(
  cpu %>% select(transistor_count, date_of_introduction) %>% mutate(type = "CPU"),
  gpu %>% select(transistor_count, date_of_introduction) %>% mutate(type = "GPU"),
  ram %>% select(transistor_count, date_of_introduction) %>% mutate(type = "RAM")
) %>%
  filter(
    !is.na(date_of_introduction) & !is.na(transistor_count)
  ) %>%
  mutate(
    log_tcount = log10(transistor_count)
  )

formula <- y ~ x

p1 <- ggplot(df, aes(x = date_of_introduction, y = transistor_count)) +
  geom_point() +
  scale_y_log10() +
  annotation_logticks(sides = "l", color = "white") +
  geom_smooth(method = "glm", formula = formula) +
  stat_poly_eq(aes(label = stat(eq.label)),
               label.x = "left", label.y = "top",
               formula = formula, parse = TRUE, color = "yellow") +
  stat_poly_eq(aes(label = stat(adj.rr.label)),
              label.x = "right", label.y = "bottom",
                  formula = formula, parse = TRUE, color = "yellow") +
  facet_wrap(~type) +
  labs(
    title = "Exponential growth in transistor count for CPU, GPU and RAM",
    subtitle = "Moore's Law dataset / #TidyTuesday 2019-09-03 ",
    y = "",
    x = "",
    caption = "@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  dark_theme_minimal() +
  theme(
    legend.position = "none",
    axis.text = element_text(color = "white", size = 12),
    axis.title = element_text(color = "white", size = 14),
    panel.border = element_blank(),
    axis.line = element_blank(),
    plot.margin = unit(rep(1, 4), "cm"),
    plot.title = element_text(size = 20)
  )

ggsave(
  plot = p1,
  filename = here::here("2019-09-03_moores-law/lm-models-cpu-gpu-ram.png"),
  width = 14,
  height = 9,
  device = agg_png,
  res = 300
)
