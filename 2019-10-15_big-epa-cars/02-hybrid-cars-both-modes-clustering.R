library(tidyverse)
library(factoextra)
library(ggforce)


load(
  here::here("2019-10-15_big-epa-cars/big-epa.Rdata")
)

hybrids <- big_epa_cars %>%
  mutate(
    transm = ifelse(str_detect(trany, "^Automatic"),
                    "Automatic",
                    "Manual"),
    fuelType = as.character(fuelType)
  ) %>%
  filter(hybrid)

# for the kmeans clustering
hybrids_clust <- hybrids %>%
  select(
    comb08, combA08, co2TailpipeGpm, co2TailpipeAGpm
  ) %>%
  scale()

set.seed(20191014)
fviz_nbclust(hybrids_clust, kmeans, method = "silhouette")

set.seed(20191014)
clust <- kmeans(hybrids_clust, centers = 2, nstart = 10)
clust_lbl <- c(
  str_wrap("Uses gasoline and E85, natural gas or propane as alternative", 20),
  str_wrap("Uses gas or premium gasoline and electricity as alternative", 20)
)

hybrids <- hybrids %>%
  mutate(
    clust_num = as.integer(clust$cluster),
    cluster = paste0("Cluster: ", factor(clust$cluster),
                     "\n", clust_lbl[clust$cluster])
  )

p1 <- ggplot(hybrids, aes(x = comb08, y = combA08)) +
  geom_point(aes(color = fuelType, shape = cluster)) +
  geom_mark_ellipse(aes(group = cluster,
                        label = cluster),
                    show.legend = FALSE,
                    color = "grey70") +
  labs(
    title = "Comparison of fuel economy for both modes in hybrid cars",
    subtitle = "Clustering (kmeans) using mpg and tailpipe CO2 (gr/mile) for each fuel type",
    x = "Combined mpg for main fuel",
    y = "Combined mpg for alternative fuel",
    caption = "#TidyTuesday, 2019-10-15\n@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  expand_limits(x = c(0, 60), y = c(0, 150)) +
  scale_color_viridis_d(
    guide = guide_legend(
      title = "",
      override.aes = list(shape = c(17, 19))
    )
  ) +
  guides(shape = FALSE) +
  theme_bw() +
  theme(
    plot.margin = unit(rep(1, 4), "cm"),
    plot.title = element_text(size = 32),
    plot.subtitle = element_text(size = 24),
    plot.caption = element_text(family = "fixed", size = 12),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    legend.position = c(.2, .8),
    legend.text = element_text(size = 12)
  )

p1


