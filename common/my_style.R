jmcastagnetto_style <- function() {
  if (.Platform$OS.type == "unix") {
    font <- "URWGothic"
  } else {
    font <- "sans"
  }
  ggplot2::theme(
    # Título
    plot.title = ggplot2::element_text(family=font,
                                       size=24,
                                       face="bold",
                                       color="#000000"),
    # Sub título, en itálicas
    plot.subtitle = ggplot2::element_text(family = font,
                                          size = 20,
                                          face = "italic",
                                          color = "#000000",
                                          margin = ggplot2::margin(9,0,9,0)
                                          ),
    # caption y tags en blanco
    plot.caption = ggplot2::element_blank(),
    plot.tag = ggplot2::element_blank(),
    # margen de 1cm alrededor del gráfico
    plot.margin = unit(rep(1, 4), "cm"),
    # Leyenda
    legend.position = "bottom",
    legend.text.align = 0,
    legend.background = ggplot2::element_blank(),
    legend.title = ggplot2::element_blank(),
    legend.key = ggplot2::element_blank(),
    legend.text = ggplot2::element_text(family=font,
                                        size=14,
                                        color="#000000"),
    # Ejes
    axis.title = ggplot2::element_text(family=font,
                                       size=16,
                                       color="#333333"),
    axis.text = ggplot2::element_text(family=font,
                                      size=16,
                                      color="#333333"),
    axis.text.x = ggplot2::element_text(margin=ggplot2::margin(5, b = 10)),
    axis.ticks = ggplot2::element_blank(),
    axis.line = ggplot2::element_blank(),
    # Grilla
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major.y = ggplot2::element_line(color="gray90"),
    panel.grid.major.x = ggplot2::element_blank(),
    # Fondo del gráfico
    panel.background = ggplot2::element_blank(),
    # Fondo para los paneles múltiples
    strip.background = ggplot2::element_rect(fill="peru"),
    strip.text = ggplot2::element_text(size  = 18,  hjust = 0.5, face = "bold")
  )
}
