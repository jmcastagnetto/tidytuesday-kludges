library(tidyverse)
library(lubridate)
library(extrafont)
library(tmap)

load(
  here::here(
    "2019-09-10_amusement-park-injuries/amusement-park-injuries.Rdata"
  )

)

df <- safer_parks %>%
  mutate(
    acc_state = as.character(acc_state)#,
    #yr = year(acc_date)
  ) %>%
  group_by(acc_state) %>%
  summarise(
    n_inj = sum(num_injured)
  ) %>%
  ungroup() %>%
  rename(
    region = acc_state,
    value = n_inj
  )

library(choroplethr)

# need to map state names
state_choropleth(df)

# try geofacet https://ryanhafen.com/blog/geofacet/


# df %>%
#   group_by(yr) %>%
#   e_charts(acc_state, timeline = TRUE) %>%
#   em_map("USA")  %>%
#   e_map(n_inj, map = "USA") %>%
# #  e_visual_map(n_inj) %>%
#   e_theme("infographic") %>%
#   e_timeline_opts(
#     autoPlay = TRUE,
#     rewind = TRUE
#   )
#