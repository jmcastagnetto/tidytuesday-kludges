library(tidyverse)

load(
  here::here("2019-11-12_cran-code/cran_df.Rdata")
)

cocomo_basic <- function(sloc) {
  # basic COCOMO 81, Organic
  effort = 2.4
  exp_effort = 1.05
  sched = 2.5
  exp_sched = 0.38
  kloc = sloc / 1000
  person_months = effort * (kloc ^ exp_effort)
  sched_months = sched * (kloc ^ exp_sched)
  avg_n_devs = person_months / sched_months
  sched_yrs = sched_months / 12
  avg_yr_salary = 85929
  overhead = 2.4
  cost = avg_yr_salary * sched_yrs * avg_n_devs * overhead
}

cran_pkg_devcost <- cran_df %>%
  mutate_at(
    vars(license, needs_compilation),
    fct_explicit_na
  ) %>%
  group_by(pkg_name, license, needs_compilation) %>%
  summarise(
    nfiles = sum(file, na.rm = TRUE),
    sloc = sum(code, na.rm = TRUE),
    cocomo = cocomo_basic(sloc),
    log_cocomo = log10(cocomo),
    cost_tier = cut(log_cocomo, 1:8)
  ) %>%
  mutate(
    license_type = case_when(
      str_detect(license, "Apache") ~ "Apache",
      str_detect(license, "GPL|GNU") ~ "GNU",
      str_detect(license, "BSD") ~ "BSD",
      str_detect(license, "MIT") ~ "MIT",
      str_detect(license, "Mozilla|MPL") ~ "Mozilla",
      str_detect(license, "CC") ~ "CC",
      is.na(license) ~ "Undefined",
      TRUE ~ "Other"
    ),
    needs_compilation = tolower(needs_compilation)
  ) %>%
  ungroup()

save(
  cran_pkg_devcost,
  file = here::here("2019-11-12_cran-code/cran_cocomo.Rdata")
)

ggplot(cran_pkg_devcost,
       aes(x = cost_tier,
           y = license_type)) +
  geom_bin2d() +
  scale_fill_viridis_c(option = "magma", direction = -1) +
  theme_bw()

ggplot(cran_pkg_devcost,
       aes(x = nfiles, y = cocomo,
           color = needs_compilation)) +
  geom_jitter() +
  scale_x_log10() +
  scale_y_log10() +
  facet_wrap(~license_type)

ggplot(cran_pkg_devcost,
       aes(x = nfiles, y = cocomo)) +
  geom_density_2d(alpha = 0.2) +
  geom_jitter(alpha = 0.2, size = 0.1) +
  scale_x_log10() +
  scale_y_log10() +
  facet_wrap(~license_type)


ggplot(cran_pkg_devcost,
       aes(y = sloc, x = nfiles)) +
  geom_density_2d() +
  geom_jitter(alpha = 0.2, size = 0.1) +
  scale_x_log10() +
  scale_y_log10() +
  theme_minimal() +
  facet_wrap(~license_type)


# avg developer salary USA = 85929 / year (Nov. 2019)
# https://www.ziprecruiter.com/Salaries/Software-Developer-Salary
#