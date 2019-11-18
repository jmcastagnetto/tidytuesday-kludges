library(tidyverse)
library(rcv)
library(magick)
library(cowplot)

load(here::here("2019-11-19_nz-birds/nz-birds.Rdata"))

# parameters to make dummy voter IDs
nr <- nrow(nz_bird)
ngrp <- 5
niter <- nr / ngrp
ids <- rep(seq(1:niter), each = ngrp)

# make dataframe for RCV
rcv_data <- nz_bird %>%
  rename(
    candidate = bird_breed
  ) %>%
  mutate(
    pref_voter_id = ids
  ) %>%
  select(
    pref_voter_id,
    candidate,
    vote_rank
  )
# Calculate the final results
results <- rcv_tally(rcv_data)
nrounds = ncol(results) - 1
winner = results[1, 1]

grf <- results %>%
  pivot_longer(
    cols = 2:80,
    names_to = "round",
    values_to = "votes"
  ) %>%
  mutate(
    round = str_remove(round, "round") %>%  as.integer()
  )


penguin_pic <- "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Megadyptes_antipodes_-Otago_Peninsula%2C_Dunedin%2C_New_Zealand_-family-8.jpg/1280px-Megadyptes_antipodes_-Otago_Peninsula%2C_Dunedin%2C_New_Zealand_-family-8.jpg"
img_raw <- image_read(penguin_pic)
img <- img_raw %>%
  image_colorize(80, "white")

rcv_plot <- ggplot(grf[1:(79*5), ],
       aes(x = round, y = votes,
           color = candidate,
           group = candidate)) +
  #geom_point(size = 4) +
  geom_line(size = 3) +
  labs(
    y = "Adjusted votes",
    x = "Tally round",
    title = paste0("The 2019 NZ bird of the year: ", winner),
    subtitle = paste0("Using Instant Runoff Voting (rounds = ",
                      nrounds, ") and showing the top 5 candidates"),
    caption = "#TidyTuesday, NZ birds dataset (2019-11-19) // @jmcastagnetto, Jesus M. Castagnetto"
  ) +
  scale_color_brewer(name = "Candidates", type = "qual", palette = "Set2") +
  annotate(
    geom = "text",
    x = 79,
    y = 9700,
    label = "👑",
    size = 9
  ) +
  theme_minimal_grid(12, color = "grey30") +
  theme(
    legend.position = "top",
    legend.title = element_text(face = "bold.italic"),
    plot.margin = unit(rep(1, 4), "cm"),
    plot.title = element_text(size = 24),
    plot.subtitle = element_text(size = 20),
    axis.title.y.left = element_text(size = 18, hjust = 1),
    axis.title.x.bottom = element_text(size = 18, hjust = 1),
    axis.text = element_text(size = 14)
  )

ggdraw() +
  draw_image(img) +
  draw_plot(rcv_plot)

