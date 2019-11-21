library(tidyverse)
library(rcv)
library(gghighlight)

load(here::here("2019-11-19_nz-birds/nz-birds.Rdata"))

# -- Using the RCV package

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
top10_rcv <- results[1:10, c(1, ncol(results) - 10)]

# doing the calculation
winner = FALSE
nround = 1
df = data.frame()
data <- rcv_data

while(!winner) {
  tmp_df <- data %>%
              filter(!is.na(candidate)) %>%
              filter(vote_rank == 1) %>%
              group_by(candidate) %>%
              tally() %>%
              mutate(
                pct = n / sum(n, na.rm = TRUE)
              ) %>%
              arrange(desc(n)) %>%
              ungroup()
  if(nrow(df) == 0) {
    df <- tmp_df
    colnames(df) = c("candidate", "round_1", "pct_1")
  } else {
    df <- df %>%
      full_join(
        tmp_df,
        by = "candidate"
      )
    cols = ncol(df)
    cnames <- colnames(df)[-c(cols - 1, cols)]
    colnames(df) <- c(cnames, paste0(c("round_", "pct_"), nround))
  }

  winner <- tmp_df[1, 3] > 0.5
  if(!winner) {
    last_candidate <- tmp_df[nrow(tmp_df),]$candidate
    voted_last_candidate_rank1 <- data %>%
      filter(candidate == last_candidate & vote_rank == 1) %>%
      pull(pref_voter_id) %>%
      unique()
    data <- data %>%
      filter(!(candidate == last_candidate & vote_rank == 1)) %>%
      mutate(
        vote_rank = ifelse(pref_voter_id %in% voted_last_candidate_rank1,
                           vote_rank - 1, vote_rank)
      ) %>%
      filter(
        candidate != last_candidate
      )
    print(paste0("round: ", nround, " -- eliminating: ", last_candidate))
  } else {
    winning_candidate <- tmp_df[1, ]$candidate
    winning_pct <- tmp_df[1, ]$pct
    print(paste0("*** Winner: ", winning_candidate, " after ", nround, " rounds, with ", sprintf("%.2f%%", 100 * winning_pct)))
  }
  nround <- nround + 1
}

top10_calc <- df[, c(1, ncol(df) - 21, ncol(df) - 20)] %>%
  arrange(desc(2)) %>%
  top_n(10)

# not exactly the same trajectories
bind_cols(top10_rcv, top10_calc)

plot_df <- df %>%
  pivot_longer(
    cols = 2:ncol(df),
    names_to = "measure",
    values_to = "value"
  ) %>%
  separate(
    measure,
    into = c("measure", "round"),
    sep = "_",
    convert = TRUE
  ) %>%
  filter(!is.na(value) & !is.na(candidate))

vote_plot <- plot_df %>% filter(measure == "round") %>% select(-measure)
pct_plot <- plot_df %>% filter(measure == "pct") %>% select(-measure)

ggplot(vote_plot, aes(x = round, y = value, color = candidate)) +
  geom_line(size = 2) +
  gghighlight((candidate %in% df[1:5, ]$candidate),
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
                      nround, ", calculated using RCV algorithm)\nShowing the top 5 candidates"),
    caption = "RCV Algorithm:  https://ballotpedia.org/Ranked-choice_voting_(RCV) // #TidyTuesday, NZ birds dataset (2019-11-19) // @jmcastagnetto, Jesus M. Castagnetto"
  ) +
  scale_y_continuous(labels = scales::percent, limits = c(0, .6)) +
  scale_color_brewer(name = "Candidates", type = "qual", palette = "Set2") +
  theme_bw() +
  theme(
    plot.margin = unit(c(1, 3.5, 1, 1), "cm"),
    plot.title = element_text(size = 24),
    plot.subtitle = element_text(size = 20),
    plot.caption = element_text(size = 12),
    axis.title.y.left = element_text(size = 18, hjust = 1),
    axis.title.x.bottom = element_text(size = 18, hjust = 1),
    axis.text = element_text(size = 14)
  )

ggsave(
  filename = here::here("2019-11-19_nz-birds/irv-results-algo.png"),
  width = 12,
  height = 8
)

ggplot(pct_plot, aes(x = round, y = value, color = candidate)) +
  geom_line(size = 2) +
  gghighlight((candidate %in% df[1:5, ]$candidate),
              label_key = candidate,
              use_direct_label = TRUE,
              use_group_by = FALSE,
              label_params = list(size = 7),
              unhighlighted_params = list(size  = 1, color = alpha("grey", 0.5)))  +
  geom_hline(yintercept = .50, linetype = "dashed") +
  annotate(
    geom = "label",
    label = "50%",
    x = 1,
    y = .5,
    size = 6
  ) +
  labs(
    y = "Percent of adjusted votes",
    x = "Tally round",
    title = paste0("The 2019 NZ bird of the year: ", winner),
    subtitle = paste0("Using Instant Runoff Voting (rounds = ",
                      nround, ", calculated with RCV algorithm)\nShowing the top 5 candidates"),
    caption = "RCV Algorithm: https://ballotpedia.org/Ranked-choice_voting_(RCV)\n#TidyTuesday, NZ birds dataset (2019-11-19) // @jmcastagnetto, Jesus M. Castagnetto"
  ) +
  scale_y_continuous(labels = scales::percent, limits = c(0, .6)) +
  scale_color_brewer(name = "Candidates", type = "qual", palette = "Set2") +
  theme_bw() +
  theme(
    plot.margin = unit(c(1, 3.5, 1, 1), "cm"),
    plot.title = element_text(size = 24),
    plot.subtitle = element_text(size = 20),
    plot.caption = element_text(size = 12),
    axis.title.y.left = element_text(size = 18, hjust = 1),
    axis.title.x.bottom = element_text(size = 18, hjust = 1),
    axis.text = element_text(size = 14)
  )

ggsave(
  filename = here::here("2019-11-19_nz-birds/irv-pct-results-algo.png"),
  width = 11,
  height = 8
)
