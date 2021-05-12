library(tidyverse)
library(readxl)
library(ggExtra)

data_range <- "A4:J3198"
poverty <- read_excel(
  "2021-05-11_us-broadband/data/est19all.xls",
  range = data_range,
  na = c("", ".")
  ) %>%
  janitor::clean_names() %>%
  select(
    state_fips_code,
    county_fips_code,
    postal_code,
    name,
    pct_poverty = poverty_percent_all_ages,
    pctpov_90ci_lowbound = x90_percent_ci_lower_bound_9,
    pctpov_90ci_uppbound = x90_percent_ci_upper_bound_10
  ) %>%
  unite(
    col = "fips_code",
    state_fips_code,
    county_fips_code,
    sep = ""
  ) %>%
  mutate_at(
    vars(starts_with("pct")),
    as.numeric
  ) %>%
  mutate(
    pov_class = cut(pct_poverty,
                    breaks = c(0, 10, 20, 30, 60),
                    labels = c(
                      "[0%, 10%]",
                      "(10%, 20%]",
                      "(20%, 30%]",
                      ">30%"
                    ),
                    ordered_result = TRUE,
                    include_lowest = TRUE)
  )

broadband <- read_csv(
  "2021-05-11_us-broadband/data/broadband_zip.csv",
  col_types = cols(
    .default = col_character(),
    `BROADBAND USAGE` = col_double(),
    `ERROR RANGE (MAE)(+/-)` = col_double(),
    `ERROR RANGE (95%)(+/-)` = col_double(),
    MSD = col_double()
  )
) %>%
  janitor::clean_names() %>%
  mutate(
    county_id = sprintf("%05d", as.numeric(county_id))
  ) %>%
  group_by(county_id) %>%
  summarise(
    avg_broadband_usage = mean(broadband_usage, na.rm = TRUE) * 100,
    max_broadband_usage = max(broadband_usage, na.rm = TRUE) * 100,
    min_broadband_usage = min(broadband_usage, na.rm = TRUE) * 100,
    med_broadband_usage = median(broadband_usage, na.rm = TRUE) * 100,
    n = n()
  )

merged_df <- broadband %>%
  left_join(
    poverty,
    by = c("county_id" = "fips_code")
  )

p0 <- ggplot(
  merged_df %>% filter(!is.na(pct_poverty)),
  aes(x = pov_class, y = med_broadband_usage / 100, color = pov_class)
) +
  ggbeeswarm::geom_quasirandom(alpha = .5, show.legend = FALSE) +
  geom_boxplot(fill = NA, color = "black",
               varwidth = TRUE, outlier.shape = NA) +
  scale_color_brewer(palette = "Dark2") +
  scale_y_continuous(labels = scales::percent) +
  labs(
    x = "Percentage of people in poverty",
    y = "Median of percent broadband use",
    title = "USA: Differences in broadband use by poverty group (county level)",
    subtitle = "Sources: #TidyTuesday 2021-05-11, and US Census Bureau (2019, SAIPE)",
    caption = "@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  theme_classic(base_size = 20) +
  theme(
    plot.title.position = "plot",
    plot.caption = element_text(family = "Inconsolata"),
    plot.subtitle = element_text(color = "gray40"),
    plot.margin = unit(rep(.25, 4), "cm")
  )

ggsave(
  plot = p0,
  filename = "2021-05-11_us-broadband/us-diff-broadband-poverty.png",
  width = 10,
  height = 8
)

p1 <- ggplot(
  merged_df %>% filter(!is.na(pct_poverty)),
  aes(x = pct_poverty / 100, y = med_broadband_usage / 100)
) +
  geom_point(color = NA) +
  geom_hex(bins = 50, color = "black", size = .2) +
  scale_fill_fermenter(direction = 1, palette = "YlGnBu") +
  scale_x_continuous(labels = scales::percent, limits = c(0, .5)) +
  scale_y_continuous(labels = scales::percent) +
  theme_linedraw(base_size = 20) +
  theme(
    legend.position = c(.8, .8),
    plot.title = element_text(size = 32, vjust = 0),
    plot.subtitle = element_text(colour = "grey40"),
    plot.caption = element_text(family = "Inconsolata"),
    plot.margin = unit(rep(.5, 4), "cm")
  ) +
  labs(
    fill = "Count",
    x = "Percent of people in poverty",
    y = "Median of percent broadband use",
    title = "USA: Distribution of broadband\nand poverty (county level)",
    subtitle = "Sources: #TidyTuesday 2021-05-11, and US Census Bureau (2019, SAIPE)",
    caption = "@jmcastagnetto, Jesus M. Castagnetto"
  )

p2 <- ggMarginal(p1, type = "densigram",
           xparams = list(
             fill = "red"
           ),
           yparams = list(
             fill = "slateblue"
           ))

ggsave(
  plot = p2,
  filename = "2021-05-11_us-broadband/us-dist-broadband-poverty.png",
  width = 10,
  height = 10
)
