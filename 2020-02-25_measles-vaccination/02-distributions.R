library(tidyverse)
library(ggridges)
library(patchwork)

load(
  here::here("2020-02-25_measles-vaccination/measles-vaccination.Rdata")
)

#-- mmr rates

mmr_df <- measles %>%
  filter(!is.na(mmr)) %>%
  select(state, mmr, type)

# ggplot(mmr_df,
#        aes(x = mmr, y = state, fill = type)) +
#   geom_density_ridges(show.legend = FALSE) +
#   theme_ridges(18) +
#   facet_wrap(~type, scales = "free") +
#   labs(
#     x = "",
#     y = "",
#     title = "Distribution of MMR vaccination rates by state and type of school",
#     subtitle = "#TidyTuesday, 2020-02-25: Measles vaccination",
#     caption = "@jmcastagnetto, Jesús M. Castagnetto"
#   ) +
#   theme(
#     strip.background = element_rect(fill = "peru"),
#     strip.text = element_text(color = "white", face = "bold.italic"),
#     plot.margin = unit(rep(1, 4), "cm")
#   )

df1 <- mmr_df %>%
  filter(type %in% c("BOCES", "Charter", "Kindergarten", "Nonpublic"))

df2 <- mmr_df %>%
  filter(type %in% c("Private", "Public"))

df3 <- mmr_df %>%
  filter(type == "Unknown")

pa <- ggplot(df1,
             aes(x = mmr,
                 y = fct_reorder(state, mmr,
                                 .fun = median, .desc = TRUE),
                 fill = type)) +
  geom_density_ridges(
    show.legend = FALSE,
    quantile_lines = TRUE,
    quantiles = 2
  ) +
  theme_ridges(18) +
  facet_wrap(~type, scales = "free", ncol = 1) +
  labs(
    x = "",
    y = ""
  ) +
  theme(
    strip.background = element_rect(fill = "peru"),
    strip.text = element_text(color = "white", face = "bold.italic")
  )

pb <- ggplot(df2,
             aes(x = mmr,
                 y = fct_reorder(state, mmr,
                                 .fun = median, .desc = TRUE),
                 fill = type)) +
  geom_density_ridges(
    show.legend = FALSE,
    quantile_lines = TRUE,
    quantiles = 2
  ) +
  theme_ridges(18) +
  facet_wrap(~type, scales = "free", ncol = 1) +
  labs(
    x = "",
    y = ""
  ) +
  theme(
    strip.background = element_rect(fill = "peru"),
    strip.text = element_text(color = "white", face = "bold.italic")
  )

pc <- ggplot(df3,
             aes(x = mmr,
                 y = fct_reorder(state, mmr,
                                 .fun = median, .desc = TRUE),
                 fill = type)) +
  geom_density_ridges(
    show.legend = FALSE,
    quantile_lines = TRUE,
    quantiles = 2
  ) +
  theme_ridges(18) +
  facet_wrap(~type, scales = "free", ncol = 1) +
  labs(
    x = "",
    y = ""
  ) +
  theme(
    strip.background = element_rect(fill = "peru"),
    strip.text = element_text(color = "white", face = "bold.italic")
  )

pa + pb + pc +
  plot_annotation(
    title = "Distribution of MMR vaccination rates by state and type of school",
    subtitle = "#TidyTuesday, 2020-02-25: Measles vaccination dataset.",
    caption = "Source: https://github.com/jmcastagnetto/tidytuesday-kludges // @jmcastagnetto, Jesús M. Castagnetto",
    theme =  theme(
      plot.title = element_text(size = 30),
      plot.subtitle = element_text(size = 20, face = "italic"),
      plot.caption = element_text(family = "Inconsolata", size = 14),
      plot.margin = unit(rep(1, 4), "cm")
    )
  )

ggsave(
  filename = here::here("2020-02-25_measles-vaccination/distribution-mmr-state-type.png"),
  width = 13,
  height = 15
)

#-- overall rates

overall_df <- measles %>%
  filter(!is.na(overall)) %>%
  select(state, overall, type)


# ggplot(overall_df,
#        aes(x = overall,
#            y = fct_reorder(state, overall,
#                            .fun = median, .desc = TRUE),
#            fill = type)) +
#   geom_density_ridges(
#     show.legend = FALSE,
#     rel_min_height = 0.01,
#     quantile_lines = TRUE,
#     quantiles = 2
#   ) +
#   theme_ridges(18) +
#   facet_wrap(~type, scales = "free") +
#   labs(
#     x = "",
#     y = "",
#     title = "Distribution of overall vaccination rates by state and type of school",
#     subtitle = "#TidyTuesday, 2020-02-25: Measles vaccination",
#     caption = "@jmcastagnetto, Jesús M. Castagnetto"
#   ) +
#   theme(
#     strip.background = element_rect(fill = "peru"),
#     strip.text = element_text(color = "white", face = "bold.italic"),
#     plot.margin = unit(rep(1, 4), "cm")
#   )



p1 <- ggplot(overall_df %>% filter(type != "Unknown"),
         aes(x = overall,
             y = fct_reorder(state, overall,
                             .fun = median, .desc = TRUE),
             fill = type)) +
    geom_density_ridges(
      show.legend = FALSE,
      #rel_min_height = 0.01,
      quantile_lines = TRUE,
      quantiles = 2,
      jittered_points = TRUE,
      position = position_points_jitter(width = 0.05, height = 0),
      point_shape = '|', point_size = 2, point_alpha = 1, alpha = 0.7
    ) +
    theme_ridges(18) +
    facet_wrap(~type, scales = "free", ncol = 1) +
    labs(
      x = "",
      y = ""
    ) +
    theme(
      strip.background = element_rect(fill = "peru"),
      strip.text = element_text(color = "white", face = "bold.italic")
    )

p2 <- ggplot(overall_df %>% filter(type == "Unknown"),
             aes(x = overall,
                 y = fct_reorder(state, overall,
                                 .fun = median, .desc = TRUE),
                 fill = type)) +
  geom_density_ridges(
    show.legend = FALSE,
    #rel_min_height = 0.01,
    quantile_lines = TRUE,
    quantiles = 2,
    jittered_points = TRUE,
    position = position_points_jitter(width = 0.05, height = 0),
    point_shape = '|', point_size = 1, point_alpha = 1, alpha = 0.7
  ) +
  theme_ridges(18) +
  facet_wrap(~type, scales = "free", ncol = 1) +
  labs(
    x = "",
    y = ""
  ) +
  theme(
    strip.background = element_rect(fill = "peru"),
    strip.text = element_text(color = "white", face = "bold.italic")
  )

p1 + p2 +
  plot_annotation(
    title = "Distribution of overall vaccination rates by state and type of school",
    subtitle = "#TidyTuesday, 2020-02-25: Measles vaccination dataset.",
    caption = "Source: https://github.com/jmcastagnetto/tidytuesday-kludges // @jmcastagnetto, Jesús M. Castagnetto",
    theme =  theme(
      plot.title = element_text(size = 30),
      plot.subtitle = element_text(size = 20, face = "italic"),
      plot.caption = element_text(family = "Inconsolata", size = 14),
      plot.margin = unit(rep(1, 4), "cm")
    )
  )

ggsave(
  filename = here::here("2020-02-25_measles-vaccination/distribution-overall-state-type.png"),
  width = 14,
  height = 16
)
