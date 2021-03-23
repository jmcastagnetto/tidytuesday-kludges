library(tidyverse)
library(vroom)
library(countrycode)

votes <- 'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-03-23/unvotes.csv'
roll_calls <- 'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-03-23/roll_calls.csv'
issues <- 'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-03-23/issues.csv'

votes_df <- vroom(
  votes,
  col_types = cols(.default = col_character())
)

roll_calls_df <- vroom(
  roll_calls,
  col_types = cols(
    .default = col_character(),
    date = col_date()
  )
)

issues_df <- vroom(
  issues,
  col_types = cols(.default = col_character())
)

combined_df <- votes_df %>%
  mutate(
    continent = countrycode(
      sourcevar = country_code,
      origin = "iso2c",
      destination = "continent",
      warn = FALSE
    ),
    continent = case_when( # Fix for old country names
        country %in% c("Czechoslovakia", "Federal Republic of Germany",
                       "German Democratic Republic", "Yugoslavia") ~ "Europe",
        country %in% c("Namibia", "Yemen Arab Republic",
                       "Yemen People's Republic", "Zanzibar") ~ "Africa",
        TRUE ~ continent
      ),
    vote = str_to_title(vote)
  ) %>%
  left_join(
    roll_calls_df,
    by = "rcid"
  ) %>%
  left_join(
    issues_df,
    by = "rcid"
  ) %>%
  mutate(
    year = lubridate::year(date),
    decade = year - (year %% 10)
  )

saveRDS(
  votes_df,
  file = "2021-03-23_un-votes/votes.rds"
)

saveRDS(
  roll_calls_df,
  file = "2021-03-23_un-votes/roll_calls.rds"
)

saveRDS(
  issues_df,
  file = "2021-03-23_un-votes/issues.rds"
)

saveRDS(
  combined_df,
  file = "2021-03-23_un-votes/combined_df.rds"
)
