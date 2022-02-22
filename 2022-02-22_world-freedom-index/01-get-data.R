library(readr)
library(dplyr)
library(tidyr)
library(readxl)


# World Freedom Index -----------------------------------------------------

wfi <- read_csv(
  "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-02-22/freedom.csv"
) %>%
  janitor::clean_names() %>%
  mutate(
    iso3c = countrycode::countrycode(
      country,
      origin = "country.name.en",
      destination = "iso3c"
    ),
    status = factor(
      status,
      levels = c("NF", "PF", "F"),
      ordered = TRUE
    )
  )


saveRDS(
  object = wfi,
  file = "2022-02-22_world-freedom-index/world-freedom-index.rds"
)


# Human Development Index -------------------------------------------------

download.file(
  url = "https://hdr.undp.org/sites/default/files/2020_statistical_annex_all.xlsx",
  destfile = "2022-02-22_world-freedom-index/un-hdi-2020_statistical_annex_all.xlsx"
)

hdi <- read_excel(
  path = "2022-02-22_world-freedom-index/un-hdi-2020_statistical_annex_all.xlsx",
  skip = 4,
  sheet = 3,
  na = c("", "..")
) %>%
  select(1, 2, 3, 5, 7, 9, 11, 13, 15, 17) %>%
  janitor::clean_names() %>%
  filter(!is.na(hdi_rank)) %>%
  rename(
    hdi_rank_2019 = hdi_rank
  ) %>%
  pivot_longer(
    cols = x1990:x2019,
    names_to = "year",
    names_prefix = "x",
    names_transform = as.integer,
    values_to = "hdi"
  ) %>%
  mutate(
    iso3c = countrycode::countrycode(
      country,
      origin = "country.name.en",
      destination = "iso3c"
    ),
    continent = countrycode::countrycode(
      country,
      origin = "country.name.en",
      destination = "continent"
    ),
    hdi_category = case_when(
      hdi >= 0.800 ~ "Very High",
      between(hdi, 0.700, 0.799) ~ "High",
      between(hdi, 0.550, 0.699) ~ "Medium",
      hdi < 0.550 ~ "Low"
    ),
    hdi_category = factor(
      hdi_category,
      levels = c(
        "Low",
        "Medium",
        "High",
        "Very High"
      ),
      ordered = TRUE
    )
  )

saveRDS(
  hdi,
  file = "2022-02-22_world-freedom-index/un-hdi.rds"
)


# Combine -----------------------------------------------------------------

wfi_hdi <- wfi %>%
  left_join(
    hdi %>% select(-country),
    by = c(
      "iso3c",
      "region_name" = "continent",
      "year"
    )
  )

saveRDS(
  wfi_hdi,
  file = "2022-02-22_world-freedom-index/wfi_hdi.rds"
)
