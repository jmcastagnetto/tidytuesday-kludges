library(tidyverse)
library(rcv)
library(magick)
library(gridGraphics)
library(gganimate)
library(gghighlight)

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

res_df <- results %>%
  pivot_longer(
    cols = 2:80,
    names_to = "round",
    values_to = "votes"
  ) %>%
  mutate(
    round = str_remove(round, "round") %>%  as.integer(),
    candidate = ifelse(candidate == "NA", NA, candidate)
  ) %>%
  filter(
    !is.na(candidate) & !is.na(votes)
  )

penguin_pic <- "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Megadyptes_antipodes_-Otago_Peninsula%2C_Dunedin%2C_New_Zealand_-family-8.jpg/1280px-Megadyptes_antipodes_-Otago_Peninsula%2C_Dunedin%2C_New_Zealand_-family-8.jpg"
img_raw <- image_read(penguin_pic)
img <- img_raw %>%
  image_colorize(80, "white")

top_5 <- res_df %>%
  filter(candidate %in% results[1:5, 1])

rcv_plot <- ggplot(data = res_df,
                   aes(x = round, y = votes, color = candidate, group = candidate)) +
  annotation_custom(rasterGrob(img,
                               width = unit(1.5,"npc"),
                               height = unit(1.5,"npc")),
                    -Inf, Inf, -Inf, Inf) +
  geom_line(size = 2) +
  gghighlight((candidate %in% results[1:5, 1]),
              label_key = candidate,
              use_direct_label = TRUE,
              use_group_by = FALSE,
              label_params = list(size = 7),
              unhighlighted_params = list(size  = 1, color = alpha("grey", 0.5)))  +
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
  theme_minimal(12) +
  theme(
    plot.margin = unit(c(1, 3.5, 1, 1), "cm"),
    plot.title = element_text(size = 24),
    plot.subtitle = element_text(size = 20),
    # legend.position = "top",
    # legend.title = element_text(face = "bold.italic"),
    # legend.text = element_text(size = 12),
    axis.title.y.left = element_text(size = 18, hjust = 1),
    axis.title.x.bottom = element_text(size = 18, hjust = 1),
    axis.text = element_text(size = 14)
  )

anim <- rcv_plot + transition_reveal(round)

animate(
  anim,
  nframes = 90,
  width = 900,
  height = 600,
  end_pause = 40
)

anim_save(
  filename = here::here("2019-11-19_nz-birds/animated-rcv-plot.gif")
)
