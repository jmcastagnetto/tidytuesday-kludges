library(tidyverse)
load(here::here("2020-05-12_volcano-eruptions/raw-data.Rdata"))

sulfur_long <- sulfur %>%
  mutate(
    ymd = lubridate::date_decimal(year)
  ) %>%
  pivot_longer(
    cols = c(neem, wdc),
    names_to = "source",
    values_to = "sulfur",
    values_drop_na = TRUE
  ) %>%
  filter(!is.na(year)) %>%
  mutate(
    source = str_to_upper(source)
  )

eruptions_sulfur <- eruptions %>%
  filter(between(start_year,
                 min(sulfur_long$year, na.rm = TRUE),
                 max(sulfur_long$year, na.rm = TRUE)))


ggplot(data = eruptions_sulfur) +
  geom_vline(aes(xintercept = start_year),
             color = "darkgrey",
             linetype = "dashed") +
  geom_count(aes(x = start_year,
                 y = 200)) +
  geom_line(data = sulfur_long,
            aes(x = year, y = sulfur,
                group = source, color = source),
            show.legend = FALSE) +
  scale_size(name = "Number of\neruptions") +
  ggdark::dark_theme_minimal(20) +
  #scale_y_log10() +
  #annotation_logticks(sides = "l") +
  facet_wrap(~source, ncol = 1) +
  labs(
    x = "Year",
    y = "Sulfur concentration in ng/gr",
    title = "Historical sulfur content and eruptions (500 CE - 706 CE)",
    subtitle = "#TidyTuesday, 2020-05-12 ('Volcano Eruptions'), from two sources:   ",
    caption = "Code: // @jmcastagnetto, Jesus M. Castagnetto"
  )
