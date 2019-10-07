# jared likert 1-6 to a rounded up median

load(
  here::here("2019-10-01_all-the-pizza/all_the_piza.Rdata")
)

jared_answers <- tibble(
  answer = fct_inorder(
      c("Never Again", "Poor", "Fair", "Average", "Good", "Excellent"),
      ordered = TRUE
    ),
  value = 1:6
)

likert_median <- function(answer, votes) {
  resp <- tibble(
      answer = answer,
      votes = votes
    ) %>%
    group_by(answer) %>%
    summarise(
      tvotes = sum(votes)
    ) %>%
    ungroup()

  df <- tibble(
    answer = fct_inorder(
      c("Never Again", "Poor", "Fair", "Average", "Good", "Excellent"),
      ordered = TRUE
      ),
    value = 1:6
  ) %>%
  left_join(
    resp,
    by = "answer"
  ) %>%
  mutate(
    tvotes = replace_na(tvotes, 0)
  )
 vect <- rep(df$value, df$tvotes)
 median(vect)
 #overestimated_median = ceiling(median(vect))
}

summary_jared <- pizza_jared %>%
  group_by(place) %>%
  summarise(
    jared_median = likert_median(answer, votes),
    jared_score = round(10 * jared_median / 6, 2), # scale 1-10
    jared_nvotes = sum(votes, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  arrange(desc(jared_nvotes)) %>%
  filter(!is.na(jared_score))

# barstool
# scale 1-10

summary_barstool <- pizza_barstool %>%
  select(name, review_stats_all_average_score, review_stats_all_count) %>%
  rename(
    barstool_score = review_stats_all_average_score,
    barstool_nvotes = review_stats_all_count
  ) %>%
  mutate(
    barstool_score = round(barstool_score, 2)
  )

rated_pizza_locations <- pizza_locations %>%
  left_join(
    summary_jared %>%
      select(place, jared_score, jared_nvotes) %>%
      filter(jared_nvotes >= 10), # at least 10 reviews
    by = c("name" = "place")
  ) %>%
  left_join(
    summary_barstool %>%
      filter(barstool_nvotes >= 10),
    by = "name"
  ) %>%
  rowwise() %>%
  mutate(
    has_scores = sum(!is.na(jared_score), !is.na(barstool_score))
  )

table(rated_pizza_locations$has_scores)
