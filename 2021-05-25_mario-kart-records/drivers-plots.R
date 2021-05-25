library(tidyverse)

records <- readRDS("2021-05-25_mario-kart-records/orig/records.rds")
drivers <- readRDS("2021-05-25_mario-kart-records/orig/drivers.rds")

drivers_summary <- drivers %>%
  filter(!is.na(records)) %>%
  group_by(player, total, nation) %>%
  summarise(
    start_year = min(year, na.rm = TRUE),
    end_year = max(year, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  mutate(
    nation = replace_na(nation, "Unknown"),
    region =  countrycode::countryname(nation, destination = "region23") %>%
      replace_na("UNK") %>%
      factor(
        levels = c(
          "Australia and New Zealand",
          "Northern Europe",
          "Western Europe",
          "Southern Europe",
          "Northern America",
          "South America",
          "UNK"
        )
      ) %>%
      fct_collapse(
        "Western and Southern Europe" = c("Western Europe", "Southern Europe")
      ),
    year_span = (end_year - start_year) + 1
  )

p1 <- ggplot(
  drivers_summary %>% filter(region != "UNK"),
  aes(x = year_span, y = total, shape = region)
) +
  geom_jitter(size = 5, width = .05, height = .05) +
  geom_smooth(aes(group = 1), method = "gam",
              color = "black", linetype = "dashed",
              fill = "grey70") +
  scale_color_brewer(type = "qual", palette = "Dark2") +
  scale_y_log10() +
  scale_x_log10() +
  annotation_logticks(sides = "bl") +
  labs(
    title = "Mario Kart: the longer you play, the more records you break",
    subtitle = "Source: #TidyTuesday 2021-05-25 (Mario Kart records)",
    caption = "@jmcastagnetto, Jesus M. Castagnetto (2021-05-24)",
    y = "Total number of records",
    x = "Career span (years)",
    shape = "Region"
  )

pa <- p1 +
  scale_shape_manual(
    values = c("🚀", "🎈", "🍀", "💥", "🎮")
  ) +
  ggthemes::theme_few(base_size = 18, base_family = "BF Tiny Hand") +
  theme(
    plot.title.position = "plot",
    plot.title = element_text(size = 24),
    plot.subtitle = element_text(size = 20, color = "grey50"),
    plot.caption = element_text(family = "Inconsolata", size = 16),
    legend.position = c(.2, .85),
    legend.text = element_text(size = 16),
    legend.background = element_rect(color = "grey80"),
    axis.title = element_text(hjust = 1, size = 18),
    axis.text = element_text(color = "black"),
    plot.margin = unit(rep(.5, 4), "cm")
  )
pa

pb <- p1 +
  ggdark::dark_theme_classic(base_size = 18, base_family = "Wargames") +
  theme(
    plot.title.position = "plot",
    plot.title = element_text(size = 32),
    plot.subtitle = element_text(size = 20, color = "grey70"),
    plot.caption = element_text(family = "Inconsolata", size = 16),
    legend.position = c(.2, .85),
    legend.text = element_text(size = 18),
    legend.background = element_rect(color = "grey80"),
    axis.title = element_text(hjust = 1, size = 22),
    axis.text = element_text(size = 20),
    plot.margin = unit(rep(.5, 4), "cm")
  )
pb

ggsave(
  plot = pa,
  filename = "2021-05-25_mario-kart-records/tautological-career-records-plot-v1.png",
  width = 17,
  height = 12
)

ggsave(
  plot = pb,
  filename = "2021-05-25_mario-kart-records/tautological-career-records-plot-v2.png",
  width = 17,
  height = 12
)
