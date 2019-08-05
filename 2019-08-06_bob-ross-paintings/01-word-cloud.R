library(fivethirtyeight)
library(tidyverse)
library(ggwordcloud)

data("bob_ross")

bob_ross <- bob_ross %>%
  janitor::clean_names() %>%
  separate(episode, into = c("season", "episode"), sep = "E") %>%
  mutate(season = str_extract(season, "[:digit:]+")) %>%
  mutate_at(vars(season, episode), as.integer) %>%
  select(-episode_num)

# modified from http://www.sthda.com/english/wiki/word-cloud-generator-in-r-one-killer-function-to-do-everything-you-need
mk_text_df <- function(txt, lang = "en") {
  library(tm)
  library(SnowballC)

  # Load the text as a corpus
  docs <- Corpus(VectorSource(txt))
  # Convert the text to lower case
  docs <- tm_map(docs, content_transformer(tolower))
  # Remove numbers
  docs <- tm_map(docs, removeNumbers)
  # Remove stopwords for the language
  docs <- tm_map(docs, removeWords, stopwords(lang))
  # Remove punctuations
  docs <- tm_map(docs, removePunctuation)
  # Eliminate extra white spaces
  docs <- tm_map(docs, stripWhitespace)
  # stemming
  docs <- tm_map(docs, stemDocument)
  tdm <- TermDocumentMatrix(docs)
  m <- as.matrix(tdm)
  v <- sort(rowSums(m),decreasing=TRUE)
  df <- tibble(word = names(v),freq=v)
  return(df)
}

set.seed(19421129) # Bob Ross's birth date

br_titles_df <- mk_text_df(paste(bob_ross$title, collapse = " ")) %>%
  mutate(
    angle = 90 * sample(c(0, 1), n(), replace = TRUE, prob = c(60, 40))
  )

wp <- ggplot(br_titles_df, aes(label = word, size = freq,
                         color = freq, angle = angle)) +
  geom_text_wordcloud_area(rm_outside = TRUE, shape = "square") +
  scale_size_area(max_size = 24) +
  scale_color_viridis_c(option = "cividis", direction = -1) +
  labs(
    title = "Bob Ross loved mountainscapes and winter",
    subtitle = "#tidytuesday, 2019-08-06",
    caption = "@jmcastagnetto (Jesus M. Castagnetto)"
  ) +
  theme_minimal()

ggsave(
  filename = here::here("2019-08-06_bob-ross-paintings/wordcloud.png"),
  plot = wp,
  width = 12,
  height = 12,
  units = "cm"
)
