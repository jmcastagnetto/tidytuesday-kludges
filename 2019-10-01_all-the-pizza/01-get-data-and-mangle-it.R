library(tidyverse)
library(yaml)
library(ggmap)
library(zipcode)
data(zipcode)

pizza_jared <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-01/pizza_jared.csv")

pizza_barstool <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-01/pizza_barstool.csv")

pizza_datafiniti <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-01/pizza_datafiniti.csv")


# geolocate jared's places

jared_places <- unique(pizza_jared$place)
geoloc_places <- unique(c(pizza_barstool$name, pizza_datafiniti$name))
unkown_geoloc <- jared_places[!jared_places %in% geoloc_places]

api_keys <- read_yaml(
  here::here("common/api-keys.yaml")
)

register_google(key = api_keys$google)

coords <- geocode(
  paste0(unkown_geoloc, ", New York"),
  output = "latlona", source = "google"
)

jared_uniq_df <- bind_cols(
  name = unkown_geoloc,
  coords
) %>% # some were not geolocated to NY
  filter(
    str_detect(address, "ny")
  ) %>%
  mutate(
    state = "NY"
  )

pizza_datafiniti <- pizza_datafiniti %>%
  rowwise() %>%
  mutate(
    price_range = case_when(
      price_range_max <= 25 ~ "up to 25",
      price_range_max > 25 ~ "more than 25"
    ),
    cat_vector = str_split(tolower(categories), ","),
    only_pizza = prod(str_detect(cat_vector, "pizza|^restaurant$|italian restaurant"))
  ) %>%
  select(
    -cat_vector
  ) %>%
  mutate(
    state = province
  )

pizza_barstool <- pizza_barstool %>%
  mutate(
    zip = as.character(zip)
  ) %>%
  left_join(
    zipcode %>% select(zip, state),
    by = "zip"
  )

pizza_locations <- bind_rows(
  jared_uniq_df %>%
    rename(
      longitude = lon,
      latitude = lat
    ) %>%
    select(name, longitude, latitude, state) %>%
    mutate(
      price_range = NA
    ),
  pizza_barstool %>%
    select(name, longitude, latitude, state) %>%
    distinct() %>%
    mutate(
      price_range = NA
    ),
  pizza_datafiniti %>%
    select(name, longitude, latitude, state, price_range)
) %>%
  arrange(name, longitude, latitude) %>%
  filter(!is.na(latitude) | !is.na(longitude)) %>%
  distinct()

# jared likert 1-6 to a median value
jared_answers <- tibble(
  answer = fct_inorder(
    c("Never Again", "Poor", "Fair", "Average", "Good", "Excellent"),
    ordered = TRUE
  ),
  value = 1:6
)

likert_median <- function(answer, votes) {
  resp <- tibble(
    answer = answer,
    votes = votes
  ) %>%
    group_by(answer) %>%
    summarise(
      tvotes = sum(votes)
    ) %>%
    ungroup()

  df <- tibble(
    answer = fct_inorder(
      c("Never Again", "Poor", "Fair", "Average", "Good", "Excellent"),
      ordered = TRUE
    ),
    value = 1:6
  ) %>%
    left_join(
      resp,
      by = "answer"
    ) %>%
    mutate(
      tvotes = replace_na(tvotes, 0)
    )
  vect <- rep(df$value, df$tvotes)
  median(vect)
}

summary_jared <- pizza_jared %>%
  group_by(place) %>%
  summarise(
    jared_median = likert_median(answer, votes),
    jared_score = round(10 * jared_median / 6, 2), # map to scale 1-10
    jared_nvotes = sum(votes, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  arrange(desc(jared_nvotes)) %>%
  filter(!is.na(jared_score))

# barstool
# scale 1-10
summary_barstool <- pizza_barstool %>%
  select(name, review_stats_all_average_score, review_stats_all_count) %>%
  rename(
    barstool_score = review_stats_all_average_score,
    barstool_nvotes = review_stats_all_count
  ) %>%
  mutate(
    barstool_score = round(barstool_score, 2)
  )

rated_pizza_locations <- pizza_locations %>%
  left_join(
    summary_jared %>%
      select(place, jared_score, jared_nvotes) %>%
      filter(jared_nvotes >= 10), # at least 10 reviews
    by = c("name" = "place")
  ) %>%
  mutate( # restrict only to stores in NY for jared's data
    jared_score = ifelse(state == "NY", jared_score, NA),
    jared_nvotes = ifelse(state == "NY", jared_nvotes, NA),
  ) %>%
  left_join(
    summary_barstool %>%
      filter(barstool_nvotes >= 10),
    by = "name"
  ) %>%
  rowwise() %>%
  mutate(
    has_scores = sum(!is.na(jared_score), !is.na(barstool_score))
  )

table(rated_pizza_locations$has_scores)

# percentage of geolocated shops with ratings
100 * nrow(rated_pizza_locations %>% filter(has_scores >= 1)) / nrow(rated_pizza_locations)
# [1] 10.10391


save(
  rated_pizza_locations, pizza_locations,
  pizza_jared, pizza_barstool, pizza_datafiniti,
  file = here::here("2019-10-01_all-the-pizza/all_the_piza.Rdata")
)
