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
    select(name, longitude, latitude, state),
  pizza_barstool %>%
    select(name, longitude, latitude, state) %>%
    distinct(),
  pizza_datafiniti %>%
    select(name, longitude, latitude, state)
) %>%
  arrange(name, longitude, latitude) %>%
  filter(!is.na(latitude) | !is.na(longitude)) %>%
  distinct()

save(
  pizza_locations, pizza_jared, pizza_barstool, pizza_datafiniti,
  file = here::here("2019-10-01_all-the-pizza/all_the_piza.Rdata")
)
