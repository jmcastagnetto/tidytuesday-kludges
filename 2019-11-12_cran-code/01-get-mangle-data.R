library(tidyverse)

pkg_info <- available.packages() %>%
  as_tibble() %>%
  select(
    Package, License, NeedsCompilation
  ) %>%
  janitor::clean_names() %>%
  mutate_at(
    vars(license, needs_compilation),
    factor
  )

datasets <- tidytuesdayR::tt_load("2019-11-12")
cran_df <- datasets[[1]] %>%
  select(pkg_name, file, language, code,
         blank, comment, version) %>%
  mutate_at(
    vars(language, version),
    factor
  ) %>%
  left_join(
    pkg_info,
    by = c("pkg_name" = "package")
  ) %>%
  mutate(
    pkg_name = factor(pkg_name)
  )

save(
  pkg_info,
  cran_df,
  file = here::here("2019-11-12_cran-code/cran_df.Rdata")
)

# Refs:
# https://csse.usc.edu/csse/research/COCOMOII/cocomo_main.html
# https://dwheeler.com/sloccount/sloccount.html#cocomo
# https://lwn.net/Articles/659241/
# https://www.ics.uci.edu/~wscacchi/Papers/WOSSE-2005/Asundi.pdf