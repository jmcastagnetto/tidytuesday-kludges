library(ggalluvial)

load(
  here::here("2019-11-05_bike-walk-commutes/bike-walk-commutes.Rdata")
)

ggplot(cm_sum,
       aes(y = n_sum, axis2 = city_size, axis1 = mode,
           axis3 = rank_range,
           axis4 = state_region)) +
  geom_alluvium(aes(fill = mode), width = 1/3, show.legend = FALSE) +
  geom_stratum(width = 1/3, fill = "darkgrey", color = "black") +
  geom_label(stat = "stratum", label.strata = TRUE) +
  scale_x_discrete(limits = c("mode", "city_size", "rank_range", "state_region"),
                   labels = c("Transportation\nMode", "City Size", "Ranking", "Region"),
                   expand = c(.05, .05)) +
  scale_color_brewer(type = "qual", palette = "Set2") +
  labs(
    title = "Most people prefer walking to biking as an alternative, and the most biking happens in the West Coast",
    subtitle = "#TidyTuesday datataset on commuting by walking or cycling (2019-11-05)\nCompared by transportation mode, city size, bike-friendliness ranking and region.",
    caption = "@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  theme_void() +
  theme(
    axis.text.y = element_blank(),
    axis.text.x = element_text(size = 14, colour = "black"),
    axis.title = element_blank(),
    plot.margin = unit(rep(1, 4), "cm"),
    plot.title = element_text(size = 18),
    plot.subtitle = element_text(size = 16),
    plot.caption = element_text(size = 12),
    legend.position = "bottom"
  )
