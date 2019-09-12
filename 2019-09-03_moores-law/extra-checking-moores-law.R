# Moore's Law: f(t+2) = 2*f(t)
library(tidyverse)
library(patchwork)

load(
  here::here("2019-09-03_moores-law/moores-law.Rdata")
)

gen_df <- function(data) {
  min_yr <- min(data$date_of_introduction, na.rm = TRUE)
  max_yr <- max(data$date_of_introduction, na.rm = TRUE)
  yr_df <- data.frame(
    yr = seq(min_yr, max_yr, 1)
  )

  yr_df %>%
    left_join(
      data,
      by = c("yr" = "date_of_introduction")
    ) %>%
    group_by(yr) %>%
    summarise(
      size = mean(transistor_count, na.rm = TRUE)
    ) %>%
    mutate(
      prev2_size = lag(size, 2),
      size_ratio = size / prev2_size,
      diff = size_ratio - 2
    )
}

mk_plot <- function(df, item, title = FALSE) {
  mse = sum(df$diff^2, na.rm = TRUE) / nrow(df)
  mae = sum(abs(df$diff), na.rm = TRUE) / nrow(df)
  ggplot(df, aes(x = yr,
                 y = size_ratio)) +
    geom_point() +
    geom_linerange(aes(ymin = 2, ymax = size_ratio), color = "red") +
    geom_hline(yintercept = 2) +
    labs(
      title = ifelse(title, "Checking Moore's Law [size(t+2) = 2*size(t)]", ""),
      subtitle = glue::glue("Using the average transistor sizes for {item} -- MAE = {sprintf('%.3f', mae)}, MSE = {sprintf('%.3f', mse)}",
                            item = item, mae = mae, mse = mse),
      x = "",
      y = ""
    ) +
    theme_minimal() +
    theme(
      plot.margin = unit(rep(1, 4), "cm")
    )
}

cpu_plot <- mk_plot(gen_df(cpu), "CPU", TRUE)
gpu_plot <- mk_plot(gen_df(gpu), "GPU")
ram_plot <- mk_plot(gen_df(ram), "RAM")

combined <- (cpu_plot / gpu_plot / ram_plot) +
  labs(
    caption = "#TidyTuesday, 2019-09-03\n@jmcastagnetto - Jesus M. Castagnetto"
  )

ggsave(
  plot = combined,
  filename = here::here("2019-09-03_moores-law/checking-moores-law.png"),
  height = 9,
  width = 6
)
