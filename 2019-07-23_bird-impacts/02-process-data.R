library(readr)
library(janitor)

bird_strikes_full <- read_csv(
  here::here("2019-07-23_bird-impacts/data/strike_reports-1990_current.csv.gz")
) %>%
  clean_names() %>%
  select(incident_date:faaregion,
         operator, atype, ac_class, ac_mass,
         num_engs, type_eng,
         height, speed, phase_of_flt,
         damage, effect,
         species, birds_seen, birds_struck, size,
         sky, precip,
         cost_repairs_infl_adj,
         nr_injuries, nr_fatalities)

save(
  bird_strikes_full,
  file = here::here("2019-07-23_bird-impacts/data/bird_strikes_full.Rdata")
)
