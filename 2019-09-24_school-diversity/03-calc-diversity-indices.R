simpson_di <- function(p) {
  sum(p * (1 - p), na.rm = TRUE)
}

shannon_di <- function(p) {
  -sum(p * log(p), na.rm = TRUE)
}

df2 <-  school_diversity %>%
  rowwise() %>%
  mutate(
    simpson_index = simpson_di(c(aian, asian, black,
                                 hispanic, white, multi)/100),
    shannon_index = shannon_di(c(aian, asian, black,
                                 hispanic, white, multi)/100)
  )

ggplot(df2, aes(x = stname, color = region)) +
