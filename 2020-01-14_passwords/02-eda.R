library(tidyverse)

load(
  here::here("2020-01-14_passwords", "passwords-dataset.Rdata")
)

table(passwords$rank == passwords$rank_alt)

table(passwords$category, useNA = "ifany")

table(passwords$strength)



