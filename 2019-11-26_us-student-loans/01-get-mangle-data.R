library(tidytuesdayR)
library(tidyverse)

tt <- tt_load("2019-11-26")
loans <- tt$loans %>%
  arrange(year, quarter, agency_name) %>%
  rename(
    total_orig = total
  ) %>%
  mutate(
    year = 2000 + year,
    yq = paste(year, quarter, sep="/") %>%
      factor(ordered = TRUE),
    agency_name = factor(agency_name)
  ) %>%
  rowwise() %>%
  mutate(
    total_calc = sum(consolidation, rehabilitation,
                     voluntary_payments, wage_garnishments,
                     na.rm = TRUE),
    diff_total = abs(total_orig - total_calc),
    total_orig_ok = near(diff_total, 0),
    unpaid = sum(starting, added, -1*total_calc, na.rm = TRUE)
  ) %>%
  ungroup()

# original totals seem to be off quite often
table(loans$total_orig_ok)
# FALSE  TRUE
#   279    12

save(
  loans,
  file = here::here("2019-11-26_us-student-loans/student-loans.Rdata")
)
