library(tidyverse)
library(gganimate)
library(extrafont)

load(
  here::here("2019-09-17_national-park-visits/park-visits.Rdata")
)

df_rank <- df %>%
  filter(!is.na(year)) %>%
  arrange(year, state) %>%
  group_by(year) %>%
  mutate(
    rank = rank(-n_parks, ties.method = "first"),
    year = as.integer(year)
  ) %>%
  filter(rank <= 10) %>%  # top 10 states by number of parks per year
  ungroup()

# code blatantly stolen from: https://towardsdatascience.com/create-animated-bar-charts-using-r-31d09e5841da
# with some minor adaptations

static <- ggplot(df_rank, aes(rank, group = state,
                         fill = state, color = state)) +
  geom_tile(aes(y = n_parks/2, height = n_parks,
                width = 0.9), alpha = 0.8, color = NA) +
  geom_text(aes(y = 0, label = paste(state, "")),
            vjust = 0.2, hjust = 1) +
  geom_text(aes(y = n_parks+0.2, label = as.character(n_parks)), color = "black", hjust=0) +
  coord_flip(clip = "off", expand = FALSE) +
  scale_x_reverse() +
  guides(color = FALSE, fill = FALSE) +
  theme_void() +
  theme(
    panel.grid.major.x = element_line(size=.1, color="grey"),
    panel.grid.minor.x = element_line(size=.1, color="grey"),
    plot.title = element_text(family = "Century", size=22),
    plot.subtitle = element_text(size=16, face="italic"),
    plot.caption = element_text(family = "Inconsolata", size=10),
    plot.margin = unit(rep(1.5, 4), "cm")
  )

anim_plot <- static +
  labs(
    title = "Top 10 States by number of parks ({closest_state})",
    subtitle = "#TidyTuesday, 2019-09-17: National Park Visits dataset",
    caption = "@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  transition_states(year,
                    transition_length = 10) +
  view_follow(fixed_x = TRUE)

animate(anim_plot,
        nframes = 113*10,
        fps = 10 ,
        renderer = gifski_renderer(
          file = here::here("2019-09-17_national-park-visits/top10_numparks_yr.gif"),
          width = 1600,
          height = 1200
        ))

