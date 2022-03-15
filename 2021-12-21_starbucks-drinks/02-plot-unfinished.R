library(tidyverse)

starbucks <- readRDS("2021-12-21_starbucks-drinks/starbucks-drinks.rds")

per_size <- starbucks %>%
  filter(serv_size_m_l > 0) %>%
  group_by(size) %>%
  summarise(
    n = n(),
    avg_caff = mean(caffeine_mg_per_ml),
    min_caff = min(caffeine_mg_per_ml),
    max_caff = max(caffeine_mg_per_ml)
  )

per_product_size <- starbucks %>%
  filter(serv_size_m_l > 0) %>%
  group_by(product_name, size) %>%
  summarise(
    n = n(),
    avg_caff = mean(caffeine_mg_per_ml),
    avg_cal = mean(calories_per_ml)
  ) %>%
  ungroup() %>%
  mutate(
    product_name = str_replace(product_name, "^brewed", "Brewed")
  )

per_product_size_n5 <- per_product_size %>%
  filter(n >= 5) %>%
  mutate(
    size = factor(
      size,
      levels = c("short", "tall", "grande", "venti", "trenta"),
      ordered = TRUE
    )
  )

df1 <- per_product_size_n5 %>%
  mutate(product_name = fct_reorder(product_name, avg_caff))

ggplot(
  df1,
  aes(y = product_name, x = size)
) +
  geom_raster(aes(fill = avg_caff)) +
  scale_fill_distiller(direction = 1, na.value = NA) +
  theme_minimal()


df2 <- per_product_size_n5 %>%
  mutate(product_name = fct_reorder(product_name, avg_cal))

ggplot(
  df2,
  aes(y = product_name, x = size)
) +
  geom_raster(aes(fill = avg_cal)) +
  scale_fill_distiller(direction = 1, na.value = NA) +
  theme_minimal()

ggplot(
  per_product_size,
  aes(x = avg_caff, y = avg_cal, color = size)
) +
  geom_point() +
  facet_wrap(~size)

rank1 <- per_product_size %>%
  filter(size == "grande") %>%
  arrange(desc(avg_caff)) %>%
  select(by_caff = product_name, avg_caff) %>%
  mutate(
    rank_caff = row_number()
  ) %>%
  relocate(
    rank_caff,
    .before = 1
  )

rank2 <- per_product_size %>%
  filter(size == "grande") %>%
  arrange(desc(avg_cal)) %>%
  select(by_cal = product_name, avg_cal) %>%
  mutate(
    rank_cal = row_number()
  ) %>%
  relocate(
    rank_cal,
    .before = 1
  )


df <- bind_cols(rank1, rank2)

