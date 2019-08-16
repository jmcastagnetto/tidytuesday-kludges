  library(tidyverse)
  library(visNetwork)

  load(
    here::here("2019-08-13_roman-emperors/emperors.Rdata")
  )

  # Using visNetwork
  links_df <- df %>%
    mutate(
      cause_prev_emperor = lag(cause, 1),
      label = paste("by", cause_prev_emperor)
    ) %>%
    filter(index > 1) %>%
    rename(
      from = prev_emperor,
      to = index
    ) %>%
    select(
      from,
      to,
      label
    ) %>%
    mutate(
      font.color = "red",
      font.size = 10,
      arrows = "to"
    )

  nodes_df <- emperors %>%
    mutate(
      label = name,
      group = dynasty,
      title = paste0("Name: ", name,
                     "<br/>Dynasty: ", dynasty,
                     "<br/>Era: ", era,
                     "<br/>Rise by: ", rise,
                     "<br/>End by: ",cause),
      shape = ifelse(
        era == "Principate",
        "square",
        "triangle"
      )
    ) %>%
    rename(
      id = index
    ) %>%
    select(
      id,
      label,
      title,
      shape,
      group,
      dynasty
    ) %>%
    mutate(
      value = 2
    )

vn <- visNetwork(nodes_df, links_df,
                   main = "A Network of Roman Emperors",
                   submain = "#TidyTuesday, using the 2019-08-13 dataset",
                   footer = "@jmcastagnetto (Jesus M. Castagnetto)",
                   width = 800,
                   height = 600) %>%
    visGroups() %>%
    visOptions(
      highlightNearest = list(
        enabled = TRUE,
        degree = 1,
        hover = TRUE),
      selectedBy = "dynasty"
    ) %>%
    visInteraction(
      navigationButtons = TRUE
    ) %>%
    visLayout(
      randomSeed = 1453
    )


htmlwidgets::saveWidget(
    vn,
    file = here::here("2019-08-13_roman-emperors/visnetwork-interactive.html"))

