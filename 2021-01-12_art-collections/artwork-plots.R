library(tidyverse)
library(tidytext)

load("2021-01-12_art-collections/art-collections.Rdata")

artwork <- artwork %>%
  mutate(
    diffyrs = acquisitionYear - year,
    century = (trunc(year / 100) + 1) %>%
      as.roman() %>%
      as.character() %>%
      replace_na("Unkown") %>%
      factor(
        levels = c(
          "XVI",
          "XVII",
          "XVIII",
          "XIX",
          "XX",
          "XXI",
          "Unkown"
        ),
        ordered = TRUE
      )
  )

# Artwork: from creation to acquisition -----------------------------------

p1 <- ggplot(artwork %>% filter(century != "Unkown"),
       aes(x = diffyrs, y = century,
           fill = century, color = century)) +
  ggridges::geom_density_ridges(show.legend = FALSE) +
  labs(
    title = "How long it took for artwork to get into the collection",
    subtitle = "Tate Art Museum Collection, #TidyTuesday 2021-01-12",
    caption = "@jmcastagnetto, Jesus M. Castagnetto",
    y = "When the work was made",
    x = "Years passed from creation to acquisition"
  ) +
  ggridges::theme_ridges(18) +
  scale_fill_brewer(palette = "Dark2") +
  scale_color_brewer(palette = "Dark2") +
  theme(
    plot.caption = element_text(family = "Inconsolata")
  )

ggsave(
  p1,
  filename = "2021-01-12_art-collections/tate-artwork-creation-to-acquisition.png",
  width = 14,
  height = 9
)


# Artwork: dimensions by century ------------------------------------------

p2 <- ggplot(artwork, aes(x = width, y = height)) +
  geom_hex() +
  scale_x_log10(
    labels = scales::trans_format('log10',
                                  scales::math_format(10^.x))
  ) +
  scale_y_log10(
    labels = scales::trans_format('log10',
                                  scales::math_format(10^.x))
  ) +
  annotation_logticks() +
  scale_fill_viridis_c() +
  coord_equal() +
  facet_wrap(~century, ncol = 4) +
  labs(
    title = "Size distribution of artwork by century of creation",
    subtitle = "Tate Art Museum Collection, #TidyTuesday 2021-01-12",
    caption = "@jmcastagnetto, Jesus M. Castagnetto",
    y = "Height [mm]",
    x = "Width [mm]"
  ) +
  ggdark::dark_theme_classic(18) +
  theme(
    legend.position = c(.9, .2),
    plot.caption = element_text(family = "Inconsolata")
  )

ggsave(
  p2,
  filename = "2021-01-12_art-collections/tate-artwork-dimensions-by-century.png",
  width = 14,
  height = 9
)

# Artwork: medium used by century ----------------------------------------------

med_df <- artwork %>%
  select(century, medium) %>%
  unnest_tokens(word, medium) %>%
  anti_join(stop_words) %>%
  filter(!is.na(word)) %>%
  group_by(century, word) %>%
  tally() %>%
  ungroup() %>%
  arrange(century, desc(n)) %>%
  group_by(century) %>%
  mutate(
    pct = n / sum(n)
  ) %>%
  top_n(4, pct) %>%
  ungroup() %>%
  mutate(
    century = as.factor(century),
    word =reorder_within(word, pct, century)
  )

p3 <- ggplot(
  med_df,
  aes(x = pct, y = word, fill = word)
) +
  geom_col(show.legend = FALSE) +
  geom_text(aes(label = scales::percent(pct, accuracy = 0.1)),
            hjust = 0,
            nudge_x = 0.001,
            color = "black",
            show.legend = FALSE) +
  scale_y_reordered() +
  scale_x_continuous(labels = scales::percent_format(), expand = c(.1,0)) +
  facet_wrap(~century, scales = "free", ncol = 2) +
  labs(
    title = "Top four materials/media used in artwork by century",
    subtitle = "Tate Art Museum Collection, #TidyTuesday 2021-01-12",
    caption = "@jmcastagnetto, Jesus M. Castagnetto",
    x = "",
    y = ""
  ) +
  ggthemes::theme_tufte(18) +
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    plot.caption = element_text(family = "Inconsolata")
  )

ggsave(
  p3,
  filename = "2021-01-12_art-collections/tate-artwork-media-by-century.png",
  width = 14,
  height = 9
)
