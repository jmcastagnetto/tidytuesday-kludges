library(tidyverse)

school_diversity <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-24/school_diversity.csv") %>%
  janitor::clean_names() %>%
  left_join(
    tibble(
      st = state.abb,
      stname = state.name,
      reg = as.character(state.region),
      div = as.character(state.division)
    ),
    by = c("st")
  ) %>%
  mutate(
    # fixes for DC
    stname = ifelse(is.na(stname), "DC", stname),
    div = ifelse(is.na(div), "Middle Atlantic", div),
    reg = ifelse(is.na(reg), "South", reg),
  ) %>%
  mutate_at(
    vars(st, d_locale_txt, diverse, int_group,
         stname, reg, div, school_year),
    fct_explicit_na
  )

save(
  school_diversity,
  file = here::here("2019-09-24_school-diversity/school_diversity.Rdata")
)
