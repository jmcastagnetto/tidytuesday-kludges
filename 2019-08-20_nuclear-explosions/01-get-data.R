library(tidyverse)

explosions_url <- "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-08-20/nuclear_explosions.csv"
sipri <- read_csv(explosions_url)

# Ranges/radius from: https://nuclearweaponarchive.org/Nwfaq/Nfaq5.html#nfaq5.1
sipri <- sipri %>%
  mutate( # ranges for blast and thermal worst case scenario (not taking height into account)
    # 20psi blast range/radius
    r_blast = 0.28 * max(yield_lower, yield_upper, na.rm = TRUE)^0.33,
    # 3rd degree burns range/radius
    r_therm = 0.67 * max(yield_lower, yield_upper, na.rm = TRUE)^0.41
  )

save(sipri, file = here::here("2019-08-20_nuclear-explosions/sipri.Rdata"))
