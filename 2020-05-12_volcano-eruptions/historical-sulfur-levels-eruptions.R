library(tidyverse)
library(lubridate)
library(glue)

load(here::here("2020-05-12_volcano-eruptions/raw-data.Rdata"))

volcano_north_south <- volcano %>%
  select(volcano_number, latitude, longitude) %>%
  mutate(
    Hemisphere = if_else(latitude > 0, "Northern", "Southern")
  )

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
    source = ifelse(source == "neem",
                    "NEEM: Ice cores from Greenland",
                    "WDDC: Ice cores from Antartica")
  )

eruptions_sulfur <- eruptions %>%
  filter(between(start_year,
                 min(sulfur_long$year, na.rm = TRUE),
                 max(sulfur_long$year, na.rm = TRUE))) %>%
  left_join(
    volcano_north_south,
    by = "volcano_number"
  ) %>%
  filter(!is.na(Hemisphere)) %>%
  mutate(
    yr_dec = decimal_date(
      ymd(
        glue("{sprintf('%04d', y)}-{sprintf('%02d',m)}-{sprintf('%02d',d)}",
             y = start_year,
             m = if_else(is.na(start_month) | start_month == 0,
                         1, start_month),
             d = if_else(is.na(start_day) | start_day == 0,
                         1, start_day)
            )
      )
    )

  )


ggplot(data = eruptions_sulfur) +
  geom_vline(aes(xintercept = start_year),
             color = "orange", alpha = 0.5,
             linetype = "dashed", show.legend = TRUE) +
  geom_count(data = eruptions_sulfur %>%
               filter(Hemisphere == "Northern"),
             aes(x = start_year,
                 y = 180, color = Hemisphere)) +
  geom_count(data = eruptions_sulfur %>%
               filter(Hemisphere == "Southern"),
             aes(x = start_year,
                  y = 150, color = Hemisphere)) +
  scale_color_brewer(type = "qual", palette = "Set1") +
  geom_line(data = sulfur_long,
            aes(x = year, y = sulfur,
                group = source),
            color = "blue",
            show.legend = FALSE) +
  scale_size(name = "Number of\neruptions") +
  theme_minimal(14) +
  theme(
    strip.text = element_text(face = "bold"),
    panel.grid = element_line(color = "grey90"),
    plot.title.position = "plot",
    plot.caption.position = "plot"
  ) +
  facet_wrap(~source, ncol = 1) +
  ylim(0, 220) +
  labs(
    x = "Year",
    y = "Sulfur concentration [ng/gr]",
    title = "Historical sulfur content and eruptions (500 CE - 706 CE)",
    subtitle = "#TidyTuesday, 2020-05-12 (\"Volcano Eruptions\")",
    caption = "Code: https://bit.ly/2LBpK3U // @jmcastagnetto, Jesus M. Castagnetto"
  )

ggsave(
  filename = here::here("2020-05-12_volcano-eruptions",
                        "historical-sulfur-levels-eruptions.png"),
  width = 10,
  height = 6
)
