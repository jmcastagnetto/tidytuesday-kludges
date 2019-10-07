library(tidyverse)

ipf_lifts <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-08/ipf_lifts.csv")

ipf_lifts_proc <- ipf_lifts %>%
  left_join(
    ipf_lifts %>%
      group_by(name) %>%
      tally(),
    by = "name"
  ) %>%
  arrange(name, date)

athlete_trajectory <- ipf_lifts_proc %>%
  rename(
    Squat = best3squat_kg,
    Bench = best3bench_kg,
    Deadlift = best3deadlift_kg
  ) %>%
  pivot_longer(
    cols = c(Squat, Bench, Deadlift),
    names_to = "weight_event",
    values_to = "weight_lifted"
  ) %>%
  mutate(
    n_range = case_when(
      n < 10 ~ "events < 10",
      n >= 10 & n < 20 ~ "10 <= events < 20",
      n >= 20 & n < 30 ~ "20 <= events < 30",
      n >= 30 & n < 40 ~ "30 <= events < 40",
      n >= 40 ~ "events >= 40"
    ) %>%
      fct_inorder(ordered = TRUE)
  ) %>%
  filter(!is.na(age))

save(
  ipf_lifts, ipf_lifts_proc, athlete_trajectory,
  file = here::here("2019-10-08_international-powerlifting/ipf.Rdata")
)
