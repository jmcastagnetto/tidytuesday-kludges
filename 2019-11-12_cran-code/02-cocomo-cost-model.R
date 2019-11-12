library(tidyverse)
library(ggridges)

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
      #str_detect(license, "Mozilla|MPL") ~ "Mozilla",
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

# dist devel costs
distcost <- ggplot(cran_pkg_devcost,
       aes(x = cocomo, y = license_type, fill = license_type)
       ) +
  geom_density_ridges(
    jittered_points = TRUE,
    position = "raincloud",
    alpha = 0.7,
    scale = 0.9,
    point_size = 0.5,
    point_alpha = 0.3,
    show.legend = FALSE
    ) +
  scale_x_log10(
    labels = scales::trans_format("log10", scales::math_format(10^.x))
  ) +
  annotation_logticks(sides = "b") +
  labs(
    y = "",
    x = "Estimated Cost (USD)",
    title = "Distribution of development cost of R packages",
    subtitle = "Estimated using the Basic (Organic) COCOMO '81 model,\nand average developer salary of USD 85929 per year\nGrouped by the package license type.",
    caption = "Sources: #TidyTuesday 2019-11-12 (CRAN code dataset) - Zip Recruiter (Nov. 2019, Software Developer Salary)\n@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  scale_fill_brewer(type = "qual") +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    plot.margin = unit(rep(1, 4), "cm"),
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 18),
    plot.title = element_text(size = 28),
    plot.subtitle = element_text(size = 18),
    plot.caption = element_text(family = "fixed", size = 8),
    legend.position = c(.7, .4),
    legend.title = element_blank(),
    legend.text = element_text(size = 18)
  )

ggsave(
  plot = distcost,
  filename = here::here("2019-11-12_cran-code/distribution-costs-rigdes.png"),
  width = 10,
  height = 8
)

# ggplot(cran_pkg_devcost,
#        aes(x = cost_tier,
#            y = license_type)) +
#   geom_bin2d() +
#   scale_fill_viridis_c(option = "magma", direction = -1) +
#   theme_bw()

costnfiles <- ggplot(cran_pkg_devcost,
       aes(x = nfiles, y = cocomo,
           color = cost_tier)) +
  geom_count(show.legend = FALSE) +
  #geom_hex(bins = 10) + # art?
  scale_x_log10(
    labels = scales::trans_format("log10", scales::math_format(10^.x))
  ) +
  scale_y_log10(
    labels = scales::trans_format("log10", scales::math_format(10^.x))
  ) +
  annotation_logticks(sides = "bl") +
  labs(
    x = "Number of files per package",
    y = "Estimated Development Cost (USD)",
    title = "Development cost and number of files for R Packages",
    subtitle = "Estimated using the Basic (Organic) COCOMO '81 model,\nand average developer salary of USD 85929 per year\nColored by development cost range and separated by license type",
    caption = "Sources: #TidyTuesday 2019-11-12 (CRAN code dataset) - Zip Recruiter (Nov. 2019, Software Developer Salary)\n@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    strip.text = element_text(face = "bold.italic", size = 16),
    plot.margin = unit(rep(1, 4), "cm"),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 28),
    plot.subtitle = element_text(size = 18),
    plot.caption = element_text(family = "fixed", size = 12)
    ) +
  facet_wrap(~license_type)

ggsave(
  plot = costnfiles,
  filename = here::here("2019-11-12_cran-code/costs-vs-nfiles-by-license.png"),
  width = 11,
  height = 8
)

# ggplot(cran_pkg_devcost,
#        aes(x = nfiles, y = cocomo)) +
#   geom_density_2d(alpha = 0.2) +
#   geom_jitter(alpha = 0.2, size = 0.1) +
#   scale_x_log10() +
#   scale_y_log10() +
#   facet_wrap(~license_type)


# ggplot(cran_pkg_devcost,
#        aes(y = sloc, x = nfiles)) +
#   geom_density_2d() +
#   geom_jitter(alpha = 0.2, size = 0.1) +
#   scale_x_log10() +
#   scale_y_log10() +
#   theme_minimal() +
#   facet_wrap(~license_type)


# avg developer salary USA = 85929 / year (Nov. 2019)
# https://www.ziprecruiter.com/Salaries/Software-Developer-Salary
#