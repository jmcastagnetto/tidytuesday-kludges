library(tidyverse)
library(ggcorrplot)
library(patchwork)

data <- readRDS("2020-09-01_global-crop-yields/data/20200901-global-crop-yields.rds")

country_crops <- data$key_crop_yields %>%
  filter(!is.na(Code)) %>%
  select(-Code) %>%
  janitor::clean_names() %>%
  pivot_longer(
    cols = 3:last_col(),
    names_to = "crop",
    names_pattern = "(.+)_tonnes_per_hectare",
    values_to = "yield"
  ) %>%
  group_by(entity, crop) %>%
  mutate(
    yield_change = (yield - lag(yield)) / yield
  ) %>%
  ungroup()

regions_crops <- data$key_crop_yields %>%
  filter(is.na(Code)) %>%
  select(-Code) %>%
  janitor::clean_names() %>%
  pivot_longer(
    cols = 3:last_col(),
    names_to = "crop",
    names_pattern = "(.+)_tonnes_per_hectare",
    values_to = "yield"
  ) %>%
  group_by(entity, crop) %>%
  mutate(
    yield_change = (yield - lag(yield)) / yield
  ) %>%
  ungroup()

get_region <- function(df, region) {
  df_long <- df %>%
    filter(entity == region & !is.na(yield_change))
  df_wide <- df_long %>%
    select(-entity, -yield) %>%
    pivot_wider(
      names_from = "crop",
      values_from = "yield_change"
    ) %>%
    column_to_rownames("year")
  colnames(df_wide) <- str_replace(colnames(df_wide), "_", " ") %>%
    str_to_title()
  corr <- cor(df_wide)
  pmat <- cor_pmat(df_wide)
  return(
    list(
      data = df_long,
      corrmat = corr,
      pvalmat = pmat
    )
  )
}

mk_corrplot <- function(df, title = "") {
  ggcorrplot(
    df$corrmat,
    type = "lower",
    ggtheme = ggplot2::theme_minimal(14),
    hc.order = FALSE,
    colors = c("cyan", "lightyellow", "peru"),
    lab = TRUE,
    lab_size = 3,
    title = title,
    show.diag = FALSE,
    show.legend = FALSE
  ) +
    # labs(
    #   subtitle = "Correlation in year over year change in crop yield"
    # ) +
    theme(
      plot.title = element_text(size = 20),
      panel.grid.major.x = element_blank(),
      panel.grid.major.y = element_line(linetype = "dotted", color = "grey70")
    )
}

mk_smoothplot <- function(df, title = "") {
  ggplot(
    df %>%
      mutate(
        crop = str_replace(crop, "_", " ") %>%
          str_to_title()
      ),
    aes(x = year, y = yield_change,
        group = crop, color = crop)
  ) +
    geom_smooth(se = FALSE) +
    labs(
      title = title,
      #subtitle = "Year over year relative change of crop yield",
      x = "", y = "",
      color = "Crops"
    ) +
    scale_y_continuous(labels = scales::percent) +
    theme_minimal(14)
}

proc_region <- function(df, region) {
  reg <- get_region(df, region)
  corrplot <- mk_corrplot(reg, region)
  smoothplot <- mk_smoothplot(reg$data, region)
  reg[["corrplot"]] = corrplot
  reg[["smoothplot"]] = smoothplot
  reg
}


# All continents ----------------------------------------------------------

africa <- proc_region(regions_crops, "Africa")
asia <- proc_region(regions_crops, "Asia")
europe <- proc_region(regions_crops, "Europe")
oceania <- proc_region(regions_crops, "Oceania")
americas <- proc_region(regions_crops, "Americas")


plot_text_1 <- wrap_elements(
  grid::textGrob(
    str_wrap(
      "Looking at the year over year crop yield changes, there are definite correlations between the different types of crops, which is something to expect because of regional enviromental differences. This generates a sort of \"fingerprint\" for each continent.",
      width = 30
    ),
    x = unit(0.1, "npc"),
    just = "left",
    gp = grid::gpar(fontsize = 14)
  )
)

plot_1 <- (
  africa$corrplot +
    (
      europe$corrplot +
        labs(
          subtitle = "No cocoa beans, but I bet they like chocolate!"
        ) +
        theme(
          plot.subtitle = element_text(size = 10)
        )
    ) +
    asia$corrplot +
    oceania$corrplot +
    americas$corrplot +
    plot_text_1
)
p1_lyt <- "
AABBCC
AABBCC
DDEEFF
DDEEFF
"

plot_1 <- plot_1 +
  plot_layout(
    design = p1_lyt
  ) +
  plot_annotation(
    title = "Correlations in year over year change in crop yields by continent",
    subtitle = "Source: Our World in Data (https://ourworldindata.org/crop-yields) - #Tidytuesday, 2020-09-01",
    caption = "Code: https://github.com/jmcastagnetto/tidytuesday-kludges/ - @jmcastagnetto (Jesus M. Castagnetto)",
    theme = theme(
      plot.title = element_text(size = 24),
      plot.subtitle = element_text(size = 18),
      plot.caption = element_text(family = "Inconsolata", size = 14)
    )
  )

ggsave(
  plot = plot_1,
  filename = here::here("2020-09-01_global-crop-yields/corr-crop-reldiff-continents.png"),
  width = 14,
  height = 10
)


# the Americas ------------------------------------------------------------

northern_america <- proc_region(regions_crops, "Northern America")
central_america <- proc_region(regions_crops, "Central America")
south_america <- proc_region(regions_crops, "South America")

plot_text_2 <- wrap_elements(
  grid::textGrob(
    str_wrap(
      "Looking at the year over year crop yield changes, there are definite correlations between the different types of crops within regions, surely because of regional enviromental differences.\n\nThis generates a sort of \"fingerprint\" that distinguishes between the South, Central and Northen Americas.",
      width = 40
    ),
    x = unit(0.1, "npc"),
    just = "left",
    gp = grid::gpar(fontsize = 18)
  )
)

plot_2 <- (
  south_america$corrplot +
    central_america$corrplot +
    (
      northern_america$corrplot +
        labs(
          subtitle = "No cocoa beans, so better cut down on the chocolate"
        ) +
        theme(
          plot.subtitle = element_text(size = 10)
        )
    ) +
  (
    americas$corrplot +
      theme(
        plot.background = element_rect(color = "black", linetype = "dashed")
      )
  ) +
    plot_text_2
)

p2_lyt <- "
AABBCC
AABBCC
DDDEEE
DDDEEE
"

plot_2 <- plot_2 +
  plot_layout(
    design = p2_lyt
  ) +
  plot_annotation(
    title = "Correlations in year over year change in crop yields in the Americas",
    subtitle = "Source: Our World in Data (https://ourworldindata.org/crop-yields) - #Tidytuesday, 2020-09-01",
    caption = "Code: https://github.com/jmcastagnetto/tidytuesday-kludges/ - @jmcastagnetto (Jesus M. Castagnetto)",
    theme = theme(
      plot.title = element_text(size = 24),
      plot.subtitle = element_text(size = 18),
      plot.caption = element_text(family = "Inconsolata", size = 14)
    )
  )

ggsave(
  plot = plot_2,
  filename = here::here("2020-09-01_global-crop-yields/corr-crop-reldiff-the-americas.png"),
  width = 14,
  height = 10
)
