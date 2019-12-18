library(tidyverse)

dog_moves <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-12-17/dog_moves.csv')
dog_travel <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-12-17/dog_travel.csv')
dog_desc <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-12-17/dog_descriptions.csv')

# cleanup contact_country and contact_state for some rows

aint_countries <- c("AZ", "CT", "DC", "DE", "IL", "TN",
                        "IN", "KY", "LA", "NM", "VA", "WA")

dog_desc_clean <- dog_desc %>%
  mutate(
    contact_state = ifelse(
      contact_country %in% aint_countries,
      contact_country,
      contact_state
    ),
    contact_country = ifelse(
      contact_country %in% aint_countries,
      "US",
      contact_country
    )
  )

us_dogs <- dog_desc_clean %>%
  filter(contact_country == "US")

breeds_per_state <- us_dogs %>%
  group_by(contact_state,
           breed_primary) %>%
  tally() %>%
  arrange(
    contact_state,
    desc(n)
  ) %>%
  ungroup()

top3_breeds_per_state <- breeds_per_state %>%
  group_by(contact_state) %>%
  top_n(n = 3, wt = n)

breeds <- us_dogs %>%
  group_by(breed_primary) %>%
  tally() %>%
  arrange(
    desc(n)
  ) %>%
  ungroup() %>%
  mutate(
    breed_primary = fct_inorder(breed_primary, ordered = TRUE)
  )

save(
  dog_desc,
  dog_travel,
  dog_moves,
  dog_desc_clean,
  us_dogs,
  breeds,
  breeds_per_state,
  top3_breeds_per_state,
  file = here::here("2019-12-17_adoptable-dogs", "datasets-adoptable-dogs.Rdata")
)
