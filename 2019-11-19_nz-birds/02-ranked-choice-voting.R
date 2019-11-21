library(tidyverse)
library(rcv)
library(magick)
library(gridGraphics)
library(gganimate)
#library(cowplot)
#library(gghighlight)

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

top_5_last <- top_5 %>%
  group_by(candidate) %>%
  filter(round == max(round))

ggplot() +
  annotation_custom(rasterGrob(img,
                               width = unit(1.5,"npc"),
                               height = unit(1.6,"npc")),
                    -Inf, Inf, -Inf, Inf) +
  geom_line(data = res_df %>% filter(!is.na(votes)),
            aes(x = round, y = votes, group = candidate), size = 1, color = "grey") +
  geom_line(data = top_5,
              aes(x = round, y = votes, color = candidate, group = candidate),
              size = 2) +
  geom_segment(data = top_5_last,
               aes(x = round, xend = 81, y = votes, yend = votes, group = candidate), linetype = 2, colour = "grey") +
  geom_label(data = top_5_last,
             aes(x = 81.1, y = votes, label = candidate, color = candidate),
             size = 6,
             hjust = 0) +
  coord_cartesian(clip = 'off', expand = TRUE) +
  labs(
    y = "Adjusted votes",
    x = "Tally round",
    title = paste0("The 2019 NZ bird of the year: ", winner),
    subtitle = paste0("Using Instant Runoff Voting (rounds = ",
                      nrounds, ") and showing the top 5 candidates"),
    caption = "#TidyTuesday, NZ birds dataset (2019-11-19) // @jmcastagnetto, Jesus M. Castagnetto"
  ) +
  annotate(
     geom = "text",
     x = 79,
     y = 9700,
     label = "👑",
     size = 9
  ) +
  scale_color_brewer(name = "Candidates", type = "qual", palette = "Set2") +
  theme_minimal(12) +
  theme(
    plot.margin = unit(c(1, 5, 1, 1), "cm"),
    plot.title = element_text(size = 24),
    plot.subtitle = element_text(size = 20),
    legend.position = "none",
    #legend.title = element_text(face = "bold.italic"),
    #legend.text = element_text(size = 12),
    axis.title.y.left = element_text(size = 18, hjust = 1),
    axis.title.x.bottom = element_text(size = 18, hjust = 1),
    axis.text = element_text(size = 14)
    )

ggsave(
  filename = here::here("2019-11-19_nz-birds/irv-results.png"),
  width = 12,
  height = 8
)
