library(tidyverse)

cpu <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-03/cpu.csv")
gpu <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-03/gpu.csv")
ram <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-03/ram.csv")


ggplot(cpu, aes(x = date_of_introduction, y = transistor_count)) +
  geom_point() +
  scale_y_log10() +
  geom_smooth(method = "glm")

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

