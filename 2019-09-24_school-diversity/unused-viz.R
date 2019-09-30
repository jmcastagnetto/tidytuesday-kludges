# Not used, the resultas are not too informative

library(tidyverse)
load(
  here::here("2019-09-24_school-diversity/school_diversity.Rdata")
)

library(randomcoloR)
library(colorspace)

ethcolors <- distinctColorPalette(6) %>%
  hex2RGB() %>%
  pluck(coords) %>%
  as.data.frame() %>%
  bind_cols(
    data.frame(
      "ethnicity" = c("aian", "asian", "black",
                       "hispanic", "white", "multi")
    )
  )

df <- school_diversity %>%
  select(-leaid, -lea_name, -variance, -int_group) %>%
  pivot_longer(
    cols = c("aian", "asian", "black",
             "hispanic", "white", "multi"),
    names_to = "ethnicity",
    values_to = "pct"
  ) %>%
  mutate(
    pct = pct / 100,
    n_people = floor(pct * total)
  )

df_state_eth <- df %>%
  group_by(school_year, st, stname, ethnicity) %>%
  summarise(
    n = sum(n_people, na.rm = TRUE)
  ) %>%
  mutate(
    pct = n / sum(n)
  ) %>%
  left_join(
    ethcolors,
    by = c("ethnicity")
  ) %>%
  ungroup()

df_blendcolor <- df_state_eth %>%
  group_by(school_year, st, stname) %>%
  summarise(
    R_blend = sum(R * pct),
    G_blend = sum(G * pct),
    B_blend = sum(B * pct)
  ) %>%
  mutate(
    color = rgb(R_blend, G_blend, B_blend)
  ) %>%
  ungroup()

states_map <- map_data("state") %>%
  left_join(
    df_blendcolor %>%
      mutate(stname = tolower(stname)) %>%
      select(stname, color, school_year, st),
    by = c("region" = "stname")
  ) %>%
  filter(!is.na(school_year))
ggplot(states_map, aes(x = long, y = lat,
                       group = group, fill = color)) +
  geom_polygon() +
  facet_wrap(~school_year)

