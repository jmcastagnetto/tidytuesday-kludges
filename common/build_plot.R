create_footer <- function(extrainfo = "") {
  rect_bg <- grid::rectGrob(gp = grid::gpar(fill = "peru",
                                         col = "peru",
                                         lwd = 0, alpha = 0.7))
  made_by <- grid::textGrob(
    "@jcastagnetto / castagnetto.com / Jesus M. Castagnetto",
    x = 0.99,
    hjust = 1,
    gp = grid::gpar(fontsize = 12, fontfamily = "sans",
                    col = "black"))

  if (extrainfo == "") {
    grid::grobTree(
      rect_bg,
      made_by
    )
  } else {
    grid::grobTree(
      rect_bg,
      grid::textGrob(extrainfo,
                     x = 0.01, hjust = 0,
                     gp = grid::gpar(
                       fontfamily = "mono", fontface = "bold",
                       fontsize = 12, col = "black")),
      made_by
    )
  }
}

build_plot <- function(plot, extrainfo = "") {
  plot_footer <- create_footer(extrainfo)
  pg <- ggpubr::ggarrange(
    plot, plot_footer,
    ncol = 1, nrow = 2,
    heights = c(19, 1)
  )
  invisible(pg)
}

build_tidytuesday_plot <- function(plot, extrainfo = "") {
  build_plot(plot, paste("#TidyTuesday -", extrainfo))
}
