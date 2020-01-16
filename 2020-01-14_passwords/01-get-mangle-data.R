library(tidyverse)

passwords <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-01-14/passwords.csv')

anagrams <- read_csv(
  here::here("2020-01-14_passwords", "anagrams-signature-english.csv")
)

calc_signature <- function(x) {
  sapply(
    lapply(
      strsplit(x, NULL),
      sort),
    paste,
    collapse=""
  )
}

passwords <- passwords %>%
  mutate(
    signature = calc_signature(password)
  ) %>%
  left_join(
    anagrams,
    by = "signature"
  ) %>%
  filter(
    !is.na(password)
  ) %>%
  select(
    -font_size
  )

passwords <- passwords %>%
  mutate(
    length = str_length(password),
    n_nums = str_count(password, "\\d"),
    n_alpha = str_count(password, "[[:alpha:]]"),
    n_others = length - n_nums - n_alpha,
    # cap strength to the 0-10 range
    strength_capped = ifelse(strength > 10, 10, strength)
  )

#-- add entropy and online password cracking estimates

minutes_seconds <- 60
hours_seconds <- minutes_seconds * 60
days_seconds <- hours_seconds * 24
weeks_seconds <- days_seconds * 7
months_seconds <- days_seconds * 30.44
years_seconds <- days_seconds * 365.25

passwords <- passwords %>%
  mutate(
    online_crack_sec = case_when(
      time_unit == "seconds" ~ value,
      time_unit == "minutes" ~ value * minutes_seconds,
      time_unit == "hours" ~ value * hours_seconds,
      time_unit == "days" ~ value * days_seconds,
      time_unit == "weeks" ~ value * weeks_seconds,
      time_unit == "months" ~ value * months_seconds,
      time_unit == "years" ~ value * years_seconds
    ),
    entropy = length * log2(36)
  )

save(
  passwords, anagrams,
  file = here::here("2020-01-14_passwords", "passwords-dataset.Rdata")
)

# src: https://github.com/rfordatascience/tidytuesday/blob/master/data/2020/2020-01-14/readme.md
# data dictionary
#
# variable | class | description
# rank | double | popularity in their database of released passwords
# password | character | Actual text of the password
# category | character | What category does the password fall in to?
# value | double | Time to crack by online guessing
# time_unit | character | Time unit to match with value
# offline_crack_sec | double | Time to crack offline in seconds
# rank_alt | double | Rank 2
# strength | double | Strength = quality of password where 10 is highest, 1 is lowest, please note that these are relative to these generally bad passwords
# font_size 	double 	Used to create the graphic for KIB