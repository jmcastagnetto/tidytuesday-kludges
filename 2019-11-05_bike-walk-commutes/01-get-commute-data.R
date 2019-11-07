library(tidyverse)

cm <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-11-05/commute.csv")

# variable 	class 	description
# city 	character 	City
# state 	character 	State
# city_size 	character 	City Size
# * Small = 20K to 99,999
# * Medium = 100K to 199,999
# * Large = >= 200K
# mode 	character 	Mode of transport, either walk or bike
# n 	double 	N of individuals
# percent 	double 	Percent of total individuals
# moe 	double 	Margin of Error (percent)
# state_abb 	character 	Abbreviated state name
# state_region 	character 	ACS State region

cm <- cm %>%
  mutate(
    other = ifelse(percent != 0, (n / (percent / 100)) - n, 0)
  )

# get 2017 rankings from The League of American Byciclists
library(rvest)
url <- "https://bikeleague.org/content/state-report-cards"
xpath <- "/html/body/div[2]/div[1]/div[1]/div[6]/div[1]/div/div/div/div/div[4]/div[1]/div[1]/div/div[3]/div/div/div/div[2]/div/div/table"

doc <- read_html(url)
nodes <- html_nodes(doc, xpath = xpath)
tab <- html_table(nodes)[[1]]
ranking <- tab[2:nrow(tab),] %>%
  rename(
    rank = 1,
    state = 2
  ) %>%
  left_join(
    tibble(
      state = state.name,
      state_abb = state.abb
    ),
    by = "state"
  ) %>%
  select(-state) %>%
  mutate(
    rank = as.integer(rank)
  )

cm <- cm %>%
  left_join(
    ranking,
    by = "state_abb"
  ) %>%
  mutate(
    rank_range =case_when(
      between(rank, 1, 10) ~ "1-10",
      between(rank, 11, 20) ~ "11-20",
      between(rank, 21, 30) ~ "21-30",
      between(rank, 31, 40) ~ "31-40",
      TRUE ~ "41-50"
    )
  )

# summary

cm_sum <- cm %>%
  group_by(rank_range, state_region, city_size, mode) %>%
  summarise(
    n_sum = sum(n, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  mutate_at(
    vars(rank_range, state_region, city_size, mode),
    factor
  ) %>%
  filter(
    !is.na(state_region)
  )

save(
  cm,
  cm_sum,
  file = here::here("2019-11-05_bike-walk-commutes/bike-walk-commutes.Rdata")
)
