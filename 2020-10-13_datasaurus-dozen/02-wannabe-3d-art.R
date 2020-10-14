library(tidyverse)
library(rayshader)
library(rgl)
library(ggtext)

df <- readRDS("2020-10-13_datasaurus-dozen/datasaurus-dozen.rds")

datasets <- unique(df$dataset)

for (d in datasets) {
  tmp <- df %>% filter(dataset == d)
  p <- ggplot(tmp, aes(x = x, y = y)) +
    stat_density_2d(aes(fill = stat(nlevel)),
                    # color = "black",
                    # size = .2,
                    geom = "polygon",
                    bins = 60,
                    contour = TRUE,
                    show.legend = FALSE) +
    scale_fill_viridis_c(option = "magma") +
    xlim(-10, 110) +
    ylim(-10, 110) +
    coord_equal() +
    labs(
      title = "The Imaginary Geography of \"_The Datasaurus Dozen_\"",
      subtitle = paste0("_Visiting_: **", d, "** // #TidyTuesday 2020-10-13"),
      caption = "@jmcastagnetto // Jesus M. Castagnetto\nhttps://github.com/jmcastagnetto/tidytuesday-kludges",
      x = "",
      y = ""
    ) +
    theme_bw() +
    theme(
      plot.title.position = "plot",
      plot.title = element_markdown(),
      plot.subtitle = element_markdown(size = 12),
      plot.caption.position = "plot",
      plot.caption = element_text(family = "Inconsolata"),
      panel.grid = element_blank(),
      axis.line = element_blank(),
      axis.ticks = element_blank(),
      axis.text = element_blank()
    )

  plot_gg(
    p,
    scale = 300,
    width = 5,
    height = 5,
    multicore = TRUE,
    height_aes = "fill",
    theta = 30,
    phi = 45,
    zoom = .6
  )

  Sys.sleep(5) # wait a bit so the RGL window can catch up

  render_movie(
    filename = paste0("2020-10-13_datasaurus-dozen/movies/", d, ".mp4"),
    theta = 30,
    phi = 45,
    zoom = .6
  )

  rgl.clear()
}
