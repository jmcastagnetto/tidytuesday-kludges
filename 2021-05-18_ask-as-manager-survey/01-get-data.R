library(tidyverse)
library(quantmod)

survey <- read_csv(
  'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-18/survey.csv',
  col_types = cols(
    .default = col_character(),
    timestamp = col_datetime(format = "%m/%d/%Y %H:%M:%S"),
    annual_salary = col_double(),
    other_monetary_comp = col_double()
  )
)


survey_proc <- survey %>%
  mutate(
    iso3c = countrycode::countryname(country, destination = "iso3c"),
    country_name = countrycode::countrycode(iso3c,
                                            origin = "iso3c",
                                            destination = "country.name.en"),
    continent = countrycode::countrycode(iso3c,
                                            origin = "iso3c",
                                            destination = "continent"),
    currency = str_replace_all(
      currency,
      c(
        "AUD/NZD" = "AUD",
        "Other"  = NA_character_
      )
    )
  ) %>%
  filter(!is.na(currency))

currencies <- unique(survey_proc$currency)
rates <- getQuote(paste0(currencies, "USD=X")) %>%
  filter(!is.na(Last)) %>%
  rownames_to_column("symbol") %>%
  mutate(
    currency = str_sub(symbol, 1, 3)
  )

survey_proc <- survey_proc %>%
  left_join(
    rates %>%
      select(currency, rate = Last),
    by = "currency"
  ) %>%
  mutate(
    salary_usd = annual_salary * rate
  )

saveRDS(
  survey,
  file = "2021-05-18_ask-as-manager-survey/survey.rds"
)

saveRDS(
  survey_proc,
  file = "2021-05-18_ask-as-manager-survey/survey-proc.rds"
)
