library(tidyverse)
source("common/my_style.R")
source("common/build_plot.R")

load(here::here("2019-08-20_nuclear-explosions/sipri.Rdata"))

df <- sipri %>%
  filter(
    !is.na(r_blast)
  ) %>%
  mutate(
    yield_value = max(yield_lower, yield_upper, na.rm = TRUE),
    decade = (year %/% 10 ) * 10
  ) %>%
  group_by(country, decade) %>%
  summarise(
    ycumul = sum(yield_value, na.rm = TRUE)
  )

p1 <- ggplot(df, aes(x = decade, y = ycumul / 1e3, fill = country)) +
  geom_col() +
  labs(
    title = "Cummulative yields in Megatons over the years",
    subtitle = "Source: SIPRI (1945-1998) @ data is plural"
  ) +
  xlab("") +
  ylab("") +
  scale_fill_brewer(type = "qual", palette = "Dark2") +
  facet_wrap(~country, ncol = 4, scales = "free_y") +
  jmcastagnetto_style() +
  theme(
    legend.position = "none"
  )

pf1 <- build_tidytuesday_plot(p1, extrainfo = "nuclear explosions dataset, 2019-08-20")

ggsave(
  filename = here::here("2019-08-20_nuclear-explosions/yield-per-country,png"),
  device = "png",
  plot = pf1,
  width = 12,
  height = 8
)
