library(tidyverse)

pizza_jared <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-01/pizza_jared.csv")
pizza_barstool <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-01/pizza_barstool.csv")
pizza_datafiniti <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-01/pizza_datafiniti.csv") %>%
  mutate(
    price_range = paste(price_range_min, price_range_max, sep = "-")
  )

pizza_datafiniti <- pizza_datafiniti %>%
  rowwise() %>%
  mutate(
    cat_vector = str_split(tolower(categories), ","),
    only_pizza = prod(str_detect(cat_vector, "pizza|^restaurant$|italian restaurant"))
  ) %>%
  select(
    -cat_vector
  ) %>%
  distinct()

pizza_locations <- bind_rows(
  pizza_barstool %>%
    select(name, latitude, longitude),
  pizza_datafiniti %>%
    select(name, latitude, longitude)
) %>%
  arrange(name, latitude, longitude) %>%
  filter(!is.na(latitude) | !is.na(longitude)) %>%
  distinct()

save(
  pizza_locations, pizza_jared, pizza_barstool, pizza_datafiniti,
  file = here::here("2019-10-01_all-the-pizza/all_the_piza.Rdata")
)

ggplot(pizza_locations, aes(x = latitude, y = longitude)) +
  geom_point()
