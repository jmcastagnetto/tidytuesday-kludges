library(tidyverse)

chocolate <- read_csv(
  "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-01-18/chocolate.csv"
) %>%
  mutate(
    cocoa_percent = str_extract(cocoa_percent, "\\d+") %>%
      as.numeric()
  )

chocolate_df <- chocolate %>%
  mutate(
    continent = countrycode::countrycode(
      country_of_bean_origin,
      origin = "country.name.en",
      destination = "continent"
    ),
    country_company = str_replace_all(
      company_location,
      c(
        "U.A.E." = "United Arab Emirates",
        "U.S.A." = "United States",
        "^Sao Tome$" = "São Tomé & Príncipe",
        "^Sao Tome & Principe$" = "São Tomé & Príncipe",
        "St.Vincent-Grenadines" = "St. Vincent & Grenadines",
        "U.K." = "United Kingdom",
        "Wales" = "United Kingdom",
        "Scotland" = "United Kingdom",
        "Amsterdam" = "Netherlands"
      )
    ) %>%
      countrycode::countrycode(
        origin = "country.name.en",
        destination = "iso3c"
      ),
    country = countrycode::countrycode(
      country_of_bean_origin,
      origin = "country.name.en",
      destination = "iso3c"
    ),
    continent = case_when(
      country_of_bean_origin == "Principe" ~ "Africa", # Sao Tomé & Principe
      country_of_bean_origin %in% c("Sulawesi", "Sumatra") ~ "Asia",  # Indonesia
      country_of_bean_origin == "Blend" ~ "Mixed origin",
      TRUE ~ continent
    ),
    country = case_when(
      country_of_bean_origin == "Principe" ~ "STP", # Sao Tomé & Principe
      country_of_bean_origin %in% c("Sulawesi", "Sumatra") ~ "IDN",  # Indonesia
      country_of_bean_origin == "Blend" ~ "UNK",
      TRUE ~ country
    ),
    n_ingredients = str_extract(ingredients, "\\d") %>% as.numeric(),
    ingredients_list = str_extract(ingredients, "[A-Za-z,*]+")
  ) %>%
  separate_rows(
    ingredients_list,
    sep = ","
  ) %>%
  mutate(
    ingredients_list = str_replace_all(
      ingredients_list,
      c(
        "^S\\*$" = "sweetener",
        "^S$" = "sugar",
        "C" = "cocoa_butter",
        "V" = "vainilla",
        "B" = "beans",
        "L" = "lecithin",
        "^Sa$" = "salt"
      )
    ),
    ingredients_list = replace_na(ingredients_list, "unknown"),
    flag = 1
  ) %>%
  pivot_wider(
    names_from = ingredients_list,
    values_from = flag,
    values_fill = 0
  )

saveRDS(
  chocolate_df,
  "2022-01-18_chocolate/chocolate.rds"
)


