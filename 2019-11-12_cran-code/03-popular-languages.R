library(tidyverse)

load(
  here::here("2019-11-12_cran-code/cran_df.Rdata")
)

proglang <- read_csv("https://raw.githubusercontent.com/jamhall/programming-languages-csv/master/languages.csv")

langs <- cran_df %>%
  count(language, wt = code, sort = TRUE) %>%
  mutate(language = as.character(language)) %>%
  left_join(
    proglang,
    by = c("language" = "name")
  ) %>%
  mutate(
    is_proglang = !is.na(url),
    is_proglang = ifelse(str_detect(
                          language,
                          "Fortran|Jupyter|Bourne|Assembly"),
                     TRUE,
                     is_proglang),
    type = ifelse(
      is_proglang,
      "Programming language",
      "Other language"
    )
  ) %>%
  select(-url)

df <- langs %>%
  top_n(20, n) %>%
  arrange(desc(n)) %>%
  mutate(
    language = fct_inorder(language)
  )

top20lang <- ggplot(df, aes(y = language, x = n, color = type)) +
  geom_point(size = 3) +
  geom_segment(
    aes(x = 0, xend = n, y = language, yend = language),
    size = 0.7
  ) +
  scale_x_log10(
    labels = scales::trans_format("log10", scales::math_format(10^.x)),
    limits = c(1e4, 1e8)
  ) +
  annotation_logticks(sides = "b", color = "white") +
  scale_y_discrete(limits = rev(levels(df$language))) +
  labs(
    y = "",
    x = "",
    title = "Top 20 languages used in R packages by line count",
    subtitle = "#TidyTuesday CRAN Code dataset (2019-11-12)",
    caption = "@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  scale_color_manual(values = c("red", "yellow")) +
  ggdark::dark_theme_minimal() +
  theme(
    panel.grid = element_blank(),
    plot.margin = unit(rep(1, 4), "cm"),
    axis.text = element_text(size = 14, color = "white"),
    plot.title = element_text(size = 28),
    plot.subtitle = element_text(size = 24),
    plot.caption = element_text(family = "fixed", size = 14),
    legend.position = c(.7, .4),
    legend.title = element_blank(),
    legend.text = element_text(size = 18)
  )

ggsave(
  plot = top20lang,
  filename = here::here("2019-11-12_cran-code", "top20langs.png"),
  width = 12,
  height = 9
)
