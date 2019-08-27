library(tidyverse)
library(rvest)

simpsons1 <- read_html("https://en.wikipedia.org/wiki/List_of_The_Simpsons_guest_stars_(seasons_1%E2%80%9320)")

table1 <- html_node(simpsons1,
                    xpath = "/html/body/div[3]/div[3]/div[4]/div/table[2]")

tmp1 <- toString(table1) %>%
  str_replace_all("<br>", "::") %>%  # multiple roles, use an unusual separator
  str_replace_all("::\\s+", "::") %>%  # cleanup a bit
  str_replace_all("\\[[^\\]]+\\]", "") # remove references

df1 <- (read_html(tmp1) %>%
  html_table())[[1]]

simpsons2 <- read_html("https://en.wikipedia.org/wiki/List_of_The_Simpsons_guest_stars")

table2 <- html_node(simpsons2,
                    xpath = "/html/body/div[3]/div[3]/div[4]/div/table[2]")

tmp2 <- toString(table2) %>%
  str_replace_all("<br>", "::") %>%  # multiple roles, use an unusual separator
  str_replace_all("::\\s+", "::") %>%  # cleanup a bit
  str_replace_all("\\[[^\\]]+\\]", "") # remove references

df2 <- (read_html(tmp2) %>%
          html_table())[[1]]

simpsons_raw <- rbind(df1, df2) %>%
  rename(
    season = "Season",
    guest_star = "Guest star",
    role = "Role(s)",
    number = "No.",
    prod_code = "Prod. code",
    episode_title = "Episode title"
  ) %>%
  mutate(
    episode_title = str_replace_all(episode_title, '"', '')
  ) %>%
  select(
    season,
    number,
    production_code,
    episode_title,
    guest_star,
    role
  )

write_csv(
  simpsons_raw,
  path = here::here("2019-08-27_simpsons-guests/simpsons-guests.csv")
)

save(
  simpsons_raw,
  file = here::here("2019-08-27_simpsons-guests/simpsons-guests.Rdata")
)
