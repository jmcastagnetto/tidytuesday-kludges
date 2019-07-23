library(readr)
library(janitor)
library(dplyr)

bird_strikes <- read_csv(
  here::here("2019-07-23_bird-impacts/data/strike_reports-1990_current.csv.gz")
) %>%
  clean_names() %>%
  select(incident_date:faaregion,
         opid, operator, atype, ac_class, ac_mass,
         num_engs, type_eng,
         height, speed, phase_of_flt,
         damage, effect,
         species, birds_seen, birds_struck, size,
         sky, precip,
         cost_repairs_infl_adj,
         nr_injuries, nr_fatalities) %>%
  mutate(
    state = replace_na(state, "UNK"),
    damage = replace_na(damage, "U"),
    phase_of_flt = str_to_sentence(phase_of_flt),
    size = na_if(size, "#N/A") %>%
      replace_na(., "Unknown") %>%
      str_to_title(.),
    time_of_day = replace_na(time_of_day, "Unknown") %>%
      str_to_title(.),
    species = replace_na(species, "Unknown") %>% str_to_title(.),
    birds_struck = replace_na(birds_struck, "Unknown"),
    operator_type = case_when(
      opid == "MIL" ~ "Military",
      opid == "GOV" ~ "Government",
      opid == "BUS" ~ "Business",
      opid == "PVT" ~ "Private",
      TRUE ~ "Commercial"
    )
  )

save(
  bird_strikes,
  file = here::here("2019-07-23_bird-impacts/data/bird_strikes.Rdata")
)
