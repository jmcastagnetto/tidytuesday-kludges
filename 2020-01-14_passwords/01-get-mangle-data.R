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