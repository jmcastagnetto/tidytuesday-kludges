library(readr)

taxons <- read_csv("https://github.com/rfordatascience/tidytuesday/raw/master/data/2021/2021-08-24/taxonomy.csv")
lemurs <- read_csv("https://github.com/rfordatascience/tidytuesday/raw/master/data/2021/2021-08-24/lemur_data.csv")

save(
  taxons,
  lemurs,
  file = "2021-08-24_lemurs/lemurs-data.Rdata"
)
