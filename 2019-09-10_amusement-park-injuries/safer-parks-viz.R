library(tidyverse)
library(lubridate)
library(extrafont)
library(ggdark)
library(geofacet)

load(
  here::here(
    "2019-09-10_amusement-park-injuries/amusement-park-injuries.Rdata"
  )
)

df <- safer_parks %>%
  mutate(
    acc_state = as.character(acc_state),
    yr = year(acc_date),
    gender = ifelse(gender == "F",
                    "👩",
                    "👨") %>%
      fct_explicit_na("👾")
  ) %>%
  group_by(acc_state, yr, gender) %>%
  summarise(
    n_inj = sum(num_injured, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  rename(
    state = acc_state
  ) %>%
  filter(
    n_inj > 0
  )


mybreaks <- function(range) {
  if ((max(range) - min(range)) < 5 ) {
    n = 1
  } else {
    n = 2
  }
  scales::cbreaks(range, scales::pretty_breaks(n))$breaks
}


# try geofacet https://ryanhafen.com/blog/geofacet/

p1 <- ggplot(df, aes(x = yr, y = n_inj, fill = gender)) +
  geom_col(width = 0.7) +
  labs(
    title = "Amusement park injuries (USA, 2010-2017)",
    subtitle = "The most dangerous states are FL, TX and OK\n#TidyTuesday, 2019-09-10.",
    caption = "Source: https://saferparksdata.org/\n@jmcastagnetto - Jesus M. Castagnetto",
    fill = "Lifeform",
    x = "",
    y = ""
  ) +
  scale_y_continuous(labels = scales::number, breaks = mybreaks) +
  scale_fill_brewer(type = "qual", palette = "Paired") +
  facet_geo(~state, scales = "free_y") +
  theme_minimal() +
  theme(
    plot.title = element_text(family = "Lobster Two",
                              size = 34),
    plot.subtitle = element_text(size = 24),
    plot.caption = element_text(family = "Inconsolata",
                                size = 14),
    axis.text.x = element_text(angle = 90),
    legend.position = "bottom",
    legend.text = element_text(family = "Inconsolata",
                               size = 28,
                               face = "bold"),
    legend.title = element_text(size = 20),
    plot.margin = unit(rep(1, 4), "cm"),
    strip.background = element_rect(color = "peru")
  )

ggsave(
  plot = p1,
  filename = here::here("2019-09-10_amusement-park-injuries/injuries-by-state-gender.png"),
  width = 12,
  height = 10
)
