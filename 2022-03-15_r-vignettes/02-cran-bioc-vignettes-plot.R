library(tidyverse)

cran_mod <- readRDS("2022-03-15_r-vignettes/cran-vignettes.rds")
bioc_mod <- readRDS("2022-03-15_r-vignettes/bioc-vignettes.rds")

cran_summ <- cran_mod %>%
  group_by(year, package) %>% # for each year and package
  summarise( # get the max value of vignettes in each format
    rnw = max(rnw),
    rmd = max(rmd)
  ) %>%
  mutate( # classify the packages by vignette format
    type_vignettes = case_when(
      (rmd == 0 & rnw != 0) ~ "Only Rnw",
      (rnw == 0 & rmd != 0) ~ "Only Rmd",
      (rnw != 0 & rmd != 0) ~ "Both (Rnw and Rmd)",
      (rnw == 0 & rmd == 0) ~ "Nothing"
    )
  ) %>%
  group_by(year, type_vignettes) %>%
  tally() %>%
  add_column(source = "CRAN")

bioc_summ <- bioc_mod %>%
  group_by(year, package) %>%
  summarise(
    rnw = max(rnw),
    rmd = max(rmd)
  ) %>%
  mutate(
    type_vignettes = case_when(
      (rmd == 0 & rnw != 0) ~ "Only Rnw",
      (rnw == 0 & rmd != 0) ~ "Only Rmd",
      (rnw != 0 & rmd != 0) ~ "Both (Rnw and Rmd)",
      (rnw == 0 & rmd == 0) ~ "Nothing"
    )
  ) %>%
  group_by(year, type_vignettes) %>%
  tally() %>%
  add_column(source = "Bioconductor")

okabe_ito_palette <- palette.colors(4, "Okabe-Ito") %>% as.character()

plot_df <- bind_rows(cran_summ, bioc_summ) %>%
  filter(between(year, 2000, 2020))

ggplot(
  plot_df,
  aes(x = year, y = n, group = type_vignettes, color = type_vignettes)
) +
  geom_line(size = 1.5) +
  geom_point(size = 3) +
  scale_y_continuous(labels = scales::comma, n.breaks = 8) +
  scale_color_manual(values = okabe_ito_palette) +
  labs(
    title = "The number of packages without vignettes is proportionally lower in **Bioconductor** compared to **CRAN**. There is also an increase in the use of *Rmarkdown* coupled with a decrease in use of *Sweave*, but that trend is more noticable in **CRAN** than in **Bioconductor** where there are still a good number of packages using *Sweave*. Very few packages use vignettes written in both formats.",
    subtitle = "Data source: #TidyTuesday 'R vignettes' (2022-03-15) - Range: 2000 - 2020",
    caption = "@jmcastagnetto, Jesus M. Castagnetto",
    x = "",
    y = "Number of packages with a given type of vignette",
    color = "Vignettes types"
  ) +
  hrbrthemes::theme_ipsum() +
  theme(
    legend.position = "bottom",
    legend.text = element_text(size = 16),
    legend.title = element_text(size = 16),
    axis.title.y = element_text(size = 14),
    strip.background = element_rect(fill = "grey80", color = NA),
    strip.text = element_text(face = "bold.italic", size = 16),
    plot.subtitle = element_text(size = 18, color = "gray50"),
    plot.title = ggtext::element_textbox_simple(
      face = "plain",
      size = 24,
      margin = margin(t = 2, r = 0, b = 2, l = 0, unit = "line")
    ),
    plot.title.position = "plot",
    plot.caption = element_text(family = "Inconsolata", face = "plain", size = 14),
    plot.background = element_rect(fill = "white")
  ) +
  facet_wrap(~source, scales = "free_y")

ggsave(
  filename = "2022-03-15_r-vignettes/cran-bioc-vignettes.png",
  width = 14,
  height = 10
)
