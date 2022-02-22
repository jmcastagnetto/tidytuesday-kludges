library(ggplot2)
library(sf)
library(rnaturalearth)
library(patchwork)

wfi_hdi_reduced <- readRDS("2022-02-22_world-freedom-index/wfi_hdi.rds") %>%
  filter(!is.na(hdi)) %>%
  group_by(country) %>%
  filter(year == 2000 | year == 2015 | year == 2019) %>%
  mutate(
    status = case_when(
      status == "NF" ~ "Not Free",
      status == "PF" ~ "Partially Free",
      status == "F" ~ "Free"
    ),
    status = factor(
      status,
      levels = c(
        "Not Free",
        "Partially Free",
        "Free"
      ),
      ordered = TRUE
    )
  )

world <- ne_countries(type = "countries", returnclass = "sf")

world_df <- world %>%
  left_join(
    wfi_hdi_reduced,
    by = c("adm0_a3" = "iso3c")
  ) %>%
  filter(
    !is.na(hdi)
  )

p1 <- ggplot(
  world_df
) +
  geom_sf(
    aes(fill = hdi_category),
    color = "grey80", size = .2
  ) +
  coord_sf(crs = "+proj=natearth") +
  facet_grid(status~year, switch = "both") +
  theme_linedraw(14) +
  theme(
    legend.position = "bottom",
    axis.text.x = element_blank(),
    axis.ticks = element_blank(),
    strip.text = element_text(face = "bold", size = 14),
    plot.title = element_text(size = 30),
    plot.subtitle = element_text(color = "gray40"),
    plot.title.position = "plot",
    plot.caption = element_text(family = "Inconsolata", size = 14)
  ) +
  labs(
    fill = "Human Development Index category:",
    title = "Changes in freedom and human development over the years",
    subtitle = "Sources: #TidyTuesday \"Freedom in the world\" (2022-02-22), and UN Human Development Index (2020)",
    caption = "@jmcastagnetto, Jesus M. Castagnetto"
  )

ggsave(
  plot = p1,
  filename = "2022-02-22_world-freedom-index/change-freedom-hdi-over-the-years.png",
  height = 8,
  width = 14
)

# Just WFI ----------------------------------------------------------------

wfi <- readRDS("2022-02-22_world-freedom-index/wfi_hdi.rds")

world_df <- world %>%
  left_join(
    wfi,
    by = c("adm0_a3" = "iso3c")
  ) %>%
  mutate(
    status = case_when(
      status == "NF" ~ "Not Free",
      status == "PF" ~ "Partially Free",
      status == "F" ~ "Free"
    ),
    status = factor(
      status,
      levels = c(
        "Not Free",
        "Partially Free",
        "Free"
      ),
      ordered = TRUE
    )
  ) %>%
  filter(!is.na(status))

p2a <- ggplot(
  world_df %>% filter(year == 2020)
) +
  geom_sf(
    aes(fill = status),
    color = "grey80", size = .2
  ) +
  coord_sf(crs = "+proj=natearth") +
  theme_linedraw(14) +
  theme(
    legend.position = "bottom",
    axis.text.x = element_blank(),
    axis.ticks = element_blank(),
    strip.text = element_text(face = "bold", size = 14),
    #plot.title = element_text(size = 30),
    plot.subtitle = element_text(color = "gray40")#,
    #plot.title.position = "plot",
    #plot.caption = element_text(family = "Inconsolata", size = 14)
  ) +
  labs(
    fill = "",
    subtitle = "World Freedom Index (2020)"
  )

p2b <- ggplot(
  world_df %>% filter(year == 2019) %>%
    filter(!is.na(hdi))
) +
  geom_sf(
    aes(fill = hdi_category),
    color = "grey80", size = .2
  ) +
  coord_sf(crs = "+proj=natearth") +
  theme_linedraw(14) +
  theme(
    legend.position = "bottom",
    axis.text.x = element_blank(),
    axis.ticks = element_blank(),
    strip.text = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(color = "gray40")#,
  ) +
  labs(
    fill = "",
    subtitle = "Human Development Index (2019)"
  )

p2 <- p2a + p2b +
  plot_annotation(
    title = "Freedom and Human Development in the World",
    subtitle = "Sources: #TidyTuesday \"Freedom in the world\" (2022-02-22), and UN Human Development Index (2020)",
    caption = "@jmcastagnetto, Jesus M. Castagnetto"
  ) &
  theme(
    legend.position = "bottom",
    axis.text.x = element_blank(),
    axis.ticks = element_blank(),
    strip.text = element_text(face = "bold", size = 14),
    plot.title = element_text(size = 30),
    plot.subtitle = element_text(color = "gray40"),
    plot.title.position = "plot",
    plot.caption = element_text(family = "Inconsolata", size = 14)
  )
p2

ggsave(
  plot = p2,
  filename = "2022-02-22_world-freedom-index/freedom2020-hdi2019-world-map.png",
  height = 6,
  width = 16
)
