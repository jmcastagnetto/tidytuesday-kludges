library(tidyverse)

load(
  here::here("2019-12-03_philadelphia-parking-violations",
             "philly-data.Rdata")
)

ph_df2 <- ph_df %>%
  mutate(
    violation_desc = str_remove(violation_desc, fixed(" CC")) %>%
      str_remove(" +[0-9]{2}$") %>%
      str_squish() %>%
      str_replace("IMPROPER-2WAY HWY", "IMPROPER ON 2WAY HWY") %>%
      str_replace("PARKING PROHBITED", "PARKING PROHIBITED") %>%
      str_replace("PARK PROHIBITED", "PARKING PROHIBITED") %>%
      str_replace("STOP/BLOCK H[I]*WY", "STOP/BLOCK HIGHWAY") %>%
      str_replace("STOPPED SAFE ZONE", "STOPPED IN SAFE ZONE") %>%
      str_replace("ILLEGAL PLACD TKT", "ILLEGAL PLACED TICKT") %>%
      str_replace("PRK MTR IMPROPER", "PARK METER IMPROPER") %>%
      str_replace("^INTERSECTION$", "STOP IN INTERSECTION") %>%
      str_replace("STOP PROHIBITED", "STOPPING PROHIBITED") %>%
      str_replace(fixed("+4HR IN LOADING ZONE"), "LOADING ZONE") %>%
      str_trim(),
    day = lubridate::day(issue_datetime),
    month = lubridate::month(issue_datetime),
    week = lubridate::isoweek(issue_datetime),
    period = ifelse(lubridate::am(issue_datetime), "pm", "am"),
    hour = lubridate::hour(issue_datetime)
  )

type_pv <- ph_df2 %>%
  group_by(violation_desc, period) %>%
  summarise(
    n = n(),
    total_fine = sum(fine, na.rm = TRUE),
    avg_fine = mean(fine, na.rm = TRUE),
    sd_fine = sd(fine, na.rm = TRUE),
    min_fine = min(fine, na.rm = TRUE),
    max_fine = max(fine, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  arrange(period, desc(n)) %>%
  group_by(period) %>%
  mutate(
    cumm_pct_n = cumsum(n) / sum(n)
  ) %>%
  arrange(period, desc(avg_fine)) %>%
  group_by(period) %>%
  mutate(
    cumm_pct_fine = cumsum(avg_fine) / sum(avg_fine)
  )

top_95n <- type_pv %>%
  filter(cumm_pct_n < .96)

top_95fine <- type_pv %>%
  filter(cumm_pct_fine < .96)


top10_pv <- type_pv %>%
  arrange(desc(n)) %>%
  group_by(period) %>%
  top_n(10, wt = n) %>%
  arrange(period, desc(n)) %>%
  ungroup() %>%
  mutate(
    violation_desc = fct_inorder(violation_desc, ordered = TRUE)
  )

df <- top_95fine %>%
  ungroup() %>%
  arrange(period, desc(avg_fine)) %>%
  mutate(
    violation_desc = fct_inorder(violation_desc, ordered = TRUE)
  )

ggplot(df, aes(x = violation_desc, y = avg_fine,
                     fill = period)) +
  geom_col(position = "dodge", show.legend = FALSE) +
  #scale_y_log10() +
  coord_flip() +
  facet_grid(~period)

df_10plus_fines <- type_pv %>%
  filter(n >= 10) %>%
  ungroup() %>%
  arrange(period, desc(n)) %>%
  mutate(
    violation_desc = fct_inorder(violation_desc, ordered = TRUE)
  )

am_list <- type_pv %>%
  filter(period == "am" & n >= 10) %>%
  pluck("violation_desc")

pm_list <- type_pv %>%
  filter(period == "pm" & n >= 10) %>%
  pluck("violation_desc")

am_df <- ph_df2 %>%
  filter(violation_desc %in% am_list & period == "am")

ggplot(am_df, aes(x = violation_desc, y = fine,
                  fill = issuing_agency)) +
  geom_violin() +
  geom_jitter(size = .2) +
  coord_flip()


ggplot(ph_df2, aes(x = hour, y = fine,
                   fill = period)) +
  geom_violin() +
  coord_flip()

ggplot(ph_df2, aes(x = hour, y = fine,
                   fill = period)) +
  geom_point(size = .2, alpha = .3)

# to do -- check calendar heatmaps