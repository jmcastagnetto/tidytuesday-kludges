library(tidyverse)
library(lubridate)

emperors <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-08-13/emperors.csv")

predecessor <- function(idx, df) {
  emp_df <- df  %>% filter(index == idx)
  pred_df <- df %>%
    filter(index < idx) %>%
    arrange(desc(index)) %>%
    mutate(
      diff_days = int_length(
        interval(reign_end, emp_df$reign_start)
      ) / (3600 * 24)
    ) %>%
    filter(diff_days >= -1) %>%
    filter(diff_days == min(diff_days)) %>%
    select(-diff_days)
  pred_df$index
}

df <- emperors %>%
  mutate(
    prev_reign_end = lag(reign_end),
    interv_days = int_length(
                    interval(prev_reign_end, reign_start)
                  ) / (3600 * 24),
    prev_emperor = sapply(index, predecessor, .) %>%
      str_replace("c\\(", "") %>%
      str_replace("\\)", ""),
    prev_emperor = ifelse(index == 1, NA, prev_emperor)
  ) %>%
  separate_rows(
    prev_emperor
  ) %>%
  select(
    index,
    name,
    rise,
    reign_start,
    reign_end,
    cause,
    killer,
    dynasty,
    era,
    interv_days,
    prev_emperor
  )

save(
  df,
  emperors,
  file = here::here("2019-08-13_roman-emperors/emperors.Rdata")
)


# how many have interr_days >= -1
sum(df$interv_days >= -1, na.rm = TRUE)

# what % is that?
sum(df$interv_days >= -1, na.rm = TRUE) / nrow(df)
