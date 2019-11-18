library(tidyverse)

load(here::here("2019-11-19_nz-birds/nz-birds.Rdata"))

voters_info <- nz_bird %>%
  mutate(
    dt = lubridate::ymd_h(paste0(date, "T", hour), tz = "NZ")
  ) %>%
  group_by(dt) %>%
  tally() %>%
  ungroup() %>%
  mutate(
    n_voters = n / 5,
    dow = lubridate::wday(dt, label = TRUE, abbr = FALSE)
  )

ggplot(voters_info, aes(x = dow, y = n_voters, fill = dow)) +
  geom_col(show.legend = FALSE, position = "stack") +
  coord_polar() +
  theme_minimal() +
  theme(
    axis.text.y = element_blank(),
    axis.title = element_blank(),
    axis.text.x = element_text(size = 18)
  )

ggplot(voters_info, aes(x = dt, color = dow)) +
  geom_segment(aes(xend = dt, yend = n_voters, y = 0)) +
  theme_minimal() +
  theme(
    axis.text.y = element_blank(),
    axis.title = element_blank(),
    axis.text.x = element_text(size = 18)
  )

