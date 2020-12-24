library(tidyverse)
library(gganimate)

bigmac <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-12-22/big-mac.csv") %>%
  mutate(
    continent = if_else(
      iso_a3 == "EUZ",
      "Europe",
      countrycode::countrycode(iso_a3,
                               origin = "iso3c",
                               destination = "continent"
                               )

    )
  )

per_continent <- bigmac %>%
  select(date, continent, dollar_price) %>%
  mutate(
    yr = lubridate::year(date)
  )

per_continent2 <- per_continent %>%
  select(continent, dollar_price) %>%
  rename(
    continent2 = continent,
    price = dollar_price
  )

p1 <- ggplot(
  per_continent,
  aes(x = dollar_price, y = continent,
      color = continent, fill = continent)
) +
  # this is the "fixed" layer in the animation
  geom_boxplot(data = per_continent2,
               aes(x = price, y = continent2, color = continent2),
               outlier.color = "grey50",
               inherit.aes = FALSE,
               show.legend = FALSE,
               linetype = "dashed",
               lwd = 1,
               fatten = 1
  ) +
  # and this is the variable layer
  geom_violin(show.legend = FALSE,
              alpha = .5,
              draw_quantiles = c(.5),
              #trim = TRUE,
              scale = "width"
  ) +
  theme_minimal(20) +
  theme(
    axis.text.y = element_text(size = 20, color = "black"),
    plot.title.position = "plot",
    plot.caption = element_text(family = "Inconsolata")
  ) +
  scale_fill_brewer(palette = "Set1", type = "qual") +
  scale_color_brewer(palette = "Set1", type = "qual") +
  scale_x_continuous(labels = scales::dollar) +
  labs(
    title = "The distribution of the 'Big Mac index' for {closest_state}",
    subtitle = "#TidyTuesday dataset (2020-12-22)",
    x = "Equivalent price in USD",
    y = "",
    caption = "Boxplot: 2000-2020 range, Violin plot: Yearly // @jmcastagnetto, Jesus M. Castagnetto, 2020-12-23"
  )
p1
anim1 <- p1 +
  transition_states(yr)

anim_save(
  filename = "2020-12-22_bigmac-index/bigmac-price-by-continent.gif",
  animation = anim1,
  nframes = 21 * 10,
  fps = 5,
  width = 900,
  height = 600
)


