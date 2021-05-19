library(tidyverse)
library(hrbrthemes)
library(ggforce)

survey <- readRDS("2021-05-18_ask-as-manager-survey/survey-proc.rds")

df <- survey %>%
  mutate(
    gender_group = case_when(
      gender == "Man" ~ "Male",
      gender == "Woman" ~ "Female",
      TRUE ~ "Non binary/Other"
    ) %>%
      factor() %>%
      fct_rev(),
    region = countrycode::countrycode(
      iso3c,
      origin = "iso3c",
      destination = "region"
    ) %>%
      factor(),
    region23 = countrycode::countrycode(iso3c,
                                      origin = "iso3c",
                                      destination = "region23") %>%
      factor()
  ) %>%
  select(
    age_group = how_old_are_you,
    experience_group = overall_years_of_professional_experience,
    education_group = highest_level_of_education_completed,
    gender_group,
    region,
    region23,
    continent,
    salary_usd
  ) %>%
  mutate(
    experience_group = str_remove_all(experience_group, "( |years)") %>%
      str_replace_all(
        c(
          "1yearorless" = "< 1",
          "41ormore" = "41+"
        )
      ) %>%
      factor(
        levels = c(
          "< 1",
          "2-4",
          "5-7",
          "8-10",
          "11-20",
          "21-30",
          "31-40",
          "41+"
        ),
        ordered = TRUE
      ),
    education_group = replace_na(education_group, "Unknown") %>%
      factor(
        levels = c(
          "Unknown",
          "High School",
          "Some college",
          "College degree",
          "Professional degree (MD, JD, etc.)",
          "Master's degree",
          "PhD"
        ),
        ordered = TRUE
      ),
    degree_group = fct_collapse(
      education_group,
      "No Degree" = c("Unknown", "High School", "Some college"),
      "Graduate" = c("College degree", "Professional degree (MD, JD, etc.)"),
      "Posgraduate" = c("Master's degree", "PhD")
    ),
    age_group = factor(
      age_group,
      levels = c(
        "under 18",
        "18-24",
        "25-34",
        "35-44",
        "45-54",
        "55-64",
        "65 or over"
      ),
      ordered = TRUE
    ),
    continent = replace_na(continent, "Unknown"),
    continent_group = case_when(
      continent %in% c("Americas", "Europe", "Unknown") ~ continent,
      TRUE ~ "Rest of the world"
    ) %>%
      factor(),
    selected_grp = between(
      salary_usd,
      quantile(salary_usd, .05),
      quantile(salary_usd, .95)
    )
  )

# From preliminary exploration, the regions with more
# data are: Northern America and Northern Europe

import_goldman_sans()


northern <- df %>%
  filter(region23 %in% c("Northern America", "Northern Europe")) %>%
  filter(selected_grp == TRUE &
           continent_group != "Unknown" &
           education_group != "Unknown") %>%
  mutate(
    bp_color = if_else(
      degree_group == "Graduate" &
        gender_group == "Non binary/Other" &
        region23 == "Northern Europe",
      "blue",
      "black"
    )
  )

n_am <- northern %>%
  filter(continent == "Americas") %>%
  nrow() %>%
  format(big.mark = ",")

n_eu <- northern %>%
  filter(continent == "Europe") %>%
  nrow() %>%
  format(big.mark = ",")

annotation_df <- northern %>%
  filter(degree_group == "Graduate" &
           gender_group == "Non binary/Other" &
           region23 == "Northern Europe") %>%
  group_by(degree_group, gender_group, region23) %>%
  summarise(
    salary_usd = max(salary_usd, na.rm = TRUE)
  ) %>%
  add_column(txt = "This group might be an exception to the trend")

p1 <- ggplot(
  northern,
  aes(x = degree_group, y = salary_usd,
      color = degree_group,
      group = degree_group)
) +
  geom_count(
    alpha = .6,
    position = position_jitter(width = .2),
    show.legend = FALSE
  ) +
  geom_boxplot(
    color = "black",
    show.legend = FALSE,
    fill = NA,
    size = 1,
    varwidth = FALSE,
    outlier.shape = NA
) +
  geom_mark_circle(
    data = annotation_df,
    aes(label = txt),
    con.type = "straight",
    con.cap = unit(1, "mm"),
    con.colour = "blue",
    con.linetype = "dashed",
    label.colour = "blue",
    label.fill = rgb(1, 1, 1, .3),
    label.width = unit(5.5, "cm"),
    label.buffer = unit(3, "mm"),
    color = "blue",
    size = 0, # do not show the circle
    linetype = "dashed",
    show.legend = FALSE
  ) +
  scale_y_log10(
    labels = scales::dollar_format(accuracy = 1),
    limits = c(NA, 2.5E5)
  ) +
  annotation_logticks(sides = "l") +
  scale_color_brewer(type = "qual", palette = "Dark2") +
  hrbrthemes::theme_ipsum_gs(
    base_size = 16,
    strip_text_size = 18,
    plot_title_size = 24,
    subtitle_size = 20,
    axis_title_size = 16,
    axis_text_size = 14,
    subtitle_face = "italic",
    caption_family = "Inconsolata",
    caption_size = 14
  ) +
  theme(
    panel.border = element_rect(color = "grey50", fill = NA),
    plot.title.position = "plot",
    plot.subtitle = element_text(color = "gray40")
  ) +
  facet_grid(region23~gender_group) +
  labs(
    y = "Base salary (in USD)",
    x = "",
    title = "A higher education usually translates into a better salary across regions.\nBut, there is a consistent (and known) gap between genders: Males tend to get more.",
    subtitle = glue::glue("Comparison between the two regions with the most data: Northern America (N = {n_am}) and Northern Europe (N = {n_eu})"),
    caption = "Data source: #TidyTuesday (2021-05-18) & 'Ask A Manager' // @jmcastagnetto, Jesus M. Castagnetto"
  )

ggsave(
  plot = p1,
  filename = "2021-05-18_ask-as-manager-survey/comparison-gender-education-northernamerica-northerneurope.png",
  width = 14,
  height = 10
)
