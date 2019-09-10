library(tidyverse)
library(lubridate)

tx_injuries_orig <- read_csv(
  "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-10/tx_injuries.csv",
  col_types = "ccffcfcfnfccc",
  na = c(NA, "N/A", "n/a")
)

tx_injuries <- tx_injuries_orig %>%
  mutate(
    injury_date_orig = injury_date,
    injury_date2 = case_when(
      str_detect(injury_date, "##") ~ NA_character_,
      # now, convert MS Excel serial number
      # values do not contain "/"
      str_detect(injury_date, "/", negate = TRUE) ~ format(
        as.Date(as.numeric(injury_date),
                origin = "1899-12-30"),
        "%m/%d/%Y"
        ),
      TRUE ~ injury_date
    ),
    injury_date = mdy(injury_date2),
    city = str_to_title(city) %>% as.factor(),
    body_part = str_to_title(body_part),
    gender = str_to_upper(gender) %>% as.factor(),
    age = abs(age) # fix negative age
  ) %>%
  select(
    -injury_date2
  )

safer_parks_orig <- read_csv(
  "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-10/saferparks.csv",
  col_types = "fcffffffffffnncfccflllc"
)

safer_parks <- safer_parks_orig %>%
  mutate(
    acc_date = mdy(acc_date),
    gender = case_when(
      gender == "B" ~ "M",
      gender == "f" ~  "F",
      TRUE ~ gender
    ) %>% as.factor()
  )

save(
  tx_injuries_orig,
  tx_injuries,
  safer_parks_orig,
  safer_parks,
  file = here::here(
    "2019-09-10_amusement-park-injuries/amusement-park-injuries.Rdata"
  )
)
