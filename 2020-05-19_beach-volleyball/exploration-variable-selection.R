library(tidyverse)

load(here::here("2020-05-19_beach-volleyball/beach-volleyball.Rdata"))

vb_df <- vb_matches %>%
  select(
    circuit,
    year,
    gender,
    w_p1_age,
    w_p1_hgt,
    w_p1_country,
    w_p2_age,
    w_p2_hgt,
    w_p2_country,
    w_rank,
    l_p1_age,
    l_p1_hgt,
    l_p1_country,
    l_p2_age,
    l_p2_hgt,
    l_p2_country,
    l_rank,
    duration
  ) %>%
  mutate(
    w_rank = as.numeric(w_rank),
    l_rank = as.numeric(l_rank),
    gender = factor(gender),
    w_p1_country = factor(w_p1_country),
    w_p2_country = factor(w_p2_country),
    l_p1_country = factor(l_p1_country),
    l_p2_country = factor(l_p2_country),
    circuit = factor(circuit)
  ) %>%
  pivot_longer(
    cols = c(w_p1_age, w_p2_age, l_p1_age, l_p2_age),
    names_to = "status_age",
    values_to = "age"
  ) %>%
  pivot_longer(
    cols = c(w_p1_hgt, w_p2_hgt, l_p1_hgt, l_p2_hgt),
    names_to = "status_hgt",
    values_to = "hgt"
  ) %>%
  pivot_longer(
    cols = c(w_p1_country, w_p2_country, l_p1_country, l_p2_country),
    names_to = "status_country",
    values_to = "country"
  ) %>%
  pivot_longer(
    cols = c(w_rank, l_rank),
    names_to = "status_rank",
    values_to = "rank"
  ) %>%
  distinct()

save(
  vb_df,
  file = here::here("2020-05-19_beach-volleyball/vb-long.Rdata")
)
