library(tidyverse)
library(rayshader)

load(
  here::here("2019-07-23_bird-impacts/data/bird_strikes.Rdata")
)

tmp_df <- bird_strikes %>%
  mutate(
    op_type_binary = ifelse(operator_type == "Commercial",
                            operator_type,
                            "Non commercial"),
    size = forcats::fct_infreq(size, ordered = TRUE),
    operator_type = forcats::fct_infreq(operator_type,
                                        ordered = TRUE),
  )

p1 <- ggplot(tmp_df , aes(x = incident_date, y = operator_type)) +
  geom_bin2d() +
  theme_minimal() +
  labs(
    title = "Distribution of wildlife strikes 1990-2019",
    subtitle = "Source: FAA Wildlife Strike database, #Tidytuesday, 2019-07-23",
    caption = "@jmcastagnetto (Jesus M. Castagnetto)",
    x = "Incident date",
    y = "Aircraft operator type",
    fill = "Impacts"
  ) +
  scale_fill_viridis_c(option = "plasma", direction = -1) +
  facet_grid(time_of_day~size)

ggsave(
  plot = p1,
  filename  = here::here("2019-07-23_bird-impacts/wildlife-strikes-heatmap.png"),
  width = 12, height = 8, units = "in"
)

options(
  cores = 3
)

plot_gg(p1,
        multicore=TRUE,
        width=5,
        height=5,
        scale=250)

render_movie(
  filename = here::here("2019-07-23_bird-impacts/wildlife-strikes-heatmap.mp4")
)
