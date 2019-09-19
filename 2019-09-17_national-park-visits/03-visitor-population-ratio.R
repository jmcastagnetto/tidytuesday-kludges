library(tidyverse)
library(showtext)
library(usmap)
library(gganimate)

load(
  here::here("2019-09-17_national-park-visits/park-visits.Rdata")
)

font_add("Dancing Script", regular = "DancingScript-Regular.otf")
font_add("Inconsolata", regular = "Inconsolata for Powerline.otf")

showtext_auto()

states_df <- us_map("states") %>%
  select(fips, abbr, full) %>%
  distinct()

df_map <- df %>%
  filter(state != "DC") %>%  # remove DC as is an outlier
  filter(!is.na(ratio) & !is.na(year)) %>%
  rename(
    abbr = state
  ) %>%
  left_join(
    states_df,
    by = c("abbr")
  )

reduced_df <- df_map %>%
  filter(year %in% seq(1905, 2015, 10)) %>%
  mutate(
    year = as.factor(year)
  )

static_us <- plot_usmap(regions = "states",
           data = reduced_df,
           values = "ratio", color = "white") +
  scale_fill_viridis_c(
    name = "Ratio",
    option = "inferno",
    direction = -1
  ) +
  theme(
    legend.position = "right",
    legend.text = element_text(size = 12),
    legend.title = element_text(size = 14),
    plot.title = element_text(family = "Dancing Script", size=24),
    plot.caption = element_text(family = "Inconsolata", size= 12),
    plot.margin = unit(rep(1.5, 4), "cm")
  )

anim_us <- static_us +
  labs(
    title = "Ratio of visitors to population ({closest_state})",
    caption = "#TidyTuesday, 2019-09-17: National Park Visits dataset\n@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  transition_states(year,
                    transition_length = 10) +
  enter_grow() +
  exit_shrink()

n_yrs <- length(unique(reduced_df$year))

anim_gif <- animate(
  anim_us,
  nframes = n_yrs*10,
  fps = 10,
  width = 700,
  height = 500,
  rewind = FALSE
)

anim_save(
  animation = anim_gif,
  filename = here::here("2019-09-17_national-park-visits/visitors-population-ratio.gif")
)
