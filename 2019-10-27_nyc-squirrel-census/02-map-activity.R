library(tidyverse)
library(ggmap)
library(showtext)

load(
  here::here("2019-10-27_nyc-squirrel-census/nyc-squirrels.Rdata")
)

font_add_google("Mirza", "mirza")
font_add_google("Inconsolata", "inconsolata")
showtext_auto()

# -- get a NYC mao centered around Central Park

keys <- yaml::read_yaml(
  here::here("common/api-keys.yaml")
)
register_google(key = keys$google)

nyc <- get_map(c(-73.965278, 40.782222), zoom = 14,
               maptype = "")

# central_park_bb <- c(left = -73.985328, bottom = 40.762464,
#                      right = -73.946704, top = 40.803668)

title_labeller <- function(s) {
  s %>% str_replace("_", " ") %>% str_to_title()
}

shift_labeller <- function(shift) {
  s <- ifelse(shift == "AM", "Morning", "Night")
}

sq_activ_long <- sq_activ_long %>%
  mutate(
    activity = factor(activity,
                      levels = c("chowing_down",
                                 "moving_around",
                                 "making_noise"))
  )

p1 <- ggmap(nyc) +
  coord_cartesian() +
  geom_hex(data = sq_activ_long, size = 0.2,
           aes(x = long, y = lat,
               color = "grey40",
               group = effected,
               alpha = as.integer(effected)),
           bins = 30) +
  labs(
    title = "Squirrels love to eat and run around, but don't make much fuzz",
    subtitle = "#TidyTuesday, 2019-02-29: NYC Squirrel Census dataset",
    caption = "@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  scale_fill_viridis(name = "Scurry",
                     option = "plasma", direction = -1) +
  theme_minimal() +
  theme(
    #plot.margin = unit(rep(1, 4), "cm"),
    plot.title = element_text(family = "mirza", size = 32),
    plot.subtitle = element_text(family = "mirza", size = 20),
    plot.caption = element_text(family = "inconsolata", size = 18),
    strip.text = element_text(size = 18),
    axis.text = element_blank(),
    axis.title = element_blank(),
    axis.ticks = element_blank(),
    aspect.ratio = 1,
    legend.title = element_text(size = 14),
    legend.title.align = 1,
    legend.position = "bottom",
    legend.direction = "horizontal",
    legend.justification = c(0, 0),
    legend.key.width = unit(.5, "cm"),
    legend.key.height = unit(0.2, "cm")
  ) +
  guides(
    colour = FALSE,
    alpha = FALSE
  ) +
  facet_grid(shift~activity,
             labeller = labeller(shift = shift_labeller,
                                 activity = title_labeller))

ggsave(
  plot = p1,
  filename = here::here("2019-10-27_nyc-squirrel-census/squirrel-activities.png"),
  width = 5,
  height = 4
)

