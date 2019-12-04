library(tidyverse)
library(ggcal)
library(cowplot)

load(
  here::here("2019-12-03_philadelphia-parking-violations",
             "philly-data.Rdata")
)

df <- ph_df %>%
  filter(!is.na(issuing_agency)) %>%
  mutate(
    date = lubridate::date(issue_datetime)
  ) %>%
  group_by(issuing_agency, date) %>%
  summarise(
    total_fines = sum(fine, na.rm = TRUE)
  )

mk_plot <- function(df) {
  agency_lbl <- unique(df$agency)
  ggcal(df$date, df$total_fines) +
    labs(
      title = paste0("Amount of fines imposed by ", agency_lbl)
    ) +
    scale_fill_viridis_c(
      labels = scales::dollar
    ) +
    theme(
      plot.margin = unit(rep(1, 4), "cm"),
      legend.position = "bottom",
      legend.key.width = unit(1.5, "cm")
    )
}

df_nested <- df %>%
  mutate(
    agency = issuing_agency
  ) %>%
  nest(
    data = c(agency, date, total_fines)
  ) %>%
  mutate(
    plot = purrr::map(.x = data,
                      .f = ~ mk_plot(.x))
  )

p <- df_nested$plot

# -- combined plot 1
t1 <- ggplot() +
  labs(
    title = "How much each agency imposes as fines (Part 1)",
    subtitle = "#TidyTuesday 'Philadelphia Parking Violations' dataset, 2019-12-02"
  ) +
  theme_void() +
  theme(
    plot.margin = unit(rep(1, 4), "cm"),
    plot.title = element_text(size = 32),
    plot.subtitle = element_text(size = 18)
  )
cap <- ggplot() +
  labs(
    title = "@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  theme_void() +
  theme(
    plot.margin = unit(rep(1, 4), "cm"),
    plot.title = element_text(size = 12, hjust = 1)
  )
g1 <- plot_grid(p[[1]], p[[2]], p[[3]], p[[4]], p[[5]], ncol = 3)

pg1 <- plot_grid(t1, g1, cap, ncol = 1, rel_heights = c(.15, 1, .1))

ggsave(
  pg1,
  filename = here::here("2019-12-03_philadelphia-parking-violations", "fines-per-agency-p1.png"),
  width = 12,
  height = 14
)

ggsave(
  pg1,
  filename = here::here("2019-12-03_philadelphia-parking-violations", "fines-per-agency-p1.pdf"),
  width = 12,
  height = 14
)

# -- combined plot 2
t2 <- ggplot() +
  labs(
    title = "How much each agency imposes as fines (Part 2)",
    subtitle = "#TidyTuesday 'Philadelphia Parking Violations' dataset, 2019-12-02"
  ) +
  theme_void() +
  theme(
    plot.margin = unit(rep(1, 4), "cm"),
    plot.title = element_text(size = 32),
    plot.subtitle = element_text(size = 18)
  )

g2 <- plot_grid(p[[6]], p[[7]], p[[8]],
                p[[9]], p[[10]], ncol = 3)

pg2 <- plot_grid(t2, g2, cap, ncol = 1,
                 rel_heights = c(.15, 1, .1))

ggsave(
  pg2,
  filename = here::here("2019-12-03_philadelphia-parking-violations", "fines-per-agency-p2.png"),
  width = 12,
  height = 14
)

ggsave(
  pg2,
  filename = here::here("2019-12-03_philadelphia-parking-violations", "fines-per-agency-p2.pdf"),
  width = 12,
  height = 14
)
