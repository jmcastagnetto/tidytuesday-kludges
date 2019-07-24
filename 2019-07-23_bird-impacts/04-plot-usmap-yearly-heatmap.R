library(maps)
library(tidyverse)
library(rayshader)

us_states <- map_data("state")

load(
  here::here("2019-07-23_bird-impacts/data/bird_strikes.Rdata")
)

states_df <- data.frame(
  abb = state.abb,
  name = state.name
)

bystate_yr_df <- bird_strikes %>%
  group_by(incident_year, state) %>%
  summarise(
    impacts = n()
  ) %>%
  left_join(
    states_df,
    by = c("state" = "abb")
  ) %>%
  left_join(
    us_states %>%
      mutate(region = str_to_title(region)) %>%
      select(-subregion),
    by = c("name" = "region")
  ) %>%
  filter(
    !is.na(group)
  ) # removes Canada, Puerto Rico, Virgin Islands, and non-contiguous


p2 <- ggplot(data = bystate_yr_df) +
  geom_polygon(aes(x = long, y = lat,
                   fill = impacts, group = group),
               color = "white") +
  coord_fixed(1.3) +
  scale_fill_viridis_c(option = "plasma", direction = -1) +
  labs(
    title = "Yearly wildlife strikes frequency in the contiguous USA",
    subtitle = "Source: FAA Wildlife Strike database, #Tidytuesday, 2019-07-23",
    caption = "@jmcastagnetto (Jesus M. Castagnetto)"
  ) +
  theme_void() +
  theme(
    legend.position = "bottom",
    plot.margin = unit(c(1,1,1,1), "cm")
  ) +
  facet_wrap(~incident_year, ncol = 6)

ggsave(
  plot = p2,
  filename  = here::here("2019-07-23_bird-impacts/wildlife-strikes-usamap.png"),
  width = 12, height = 8, units = "in"
)

options(
  cores = 3
)

plot_gg(p2,
        multicore=TRUE,
        width=5,
        height=5,
        scale=250)

render_movie(
  filename = here::here("2019-07-23_bird-impacts/wildlife-strikes-usamap.mp4"),
  phi = 70
)
