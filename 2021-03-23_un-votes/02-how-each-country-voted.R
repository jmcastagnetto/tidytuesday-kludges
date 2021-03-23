library(tidyverse)

combined_df <- readRDS("2021-03-23_un-votes/combined_df.rds")
plots_df <- combined_df %>%
  filter(!is.na(issue)) %>% # remove roll calls w/o issue assigned
  group_by(country, decade, vote, issue) %>%
  tally() %>%
  ungroup() %>%
  group_nest(country) %>%
  mutate(
    plot = map2(
      .y = country, .x = data,
      ~{
        ggplot(
          data = .x,
          aes(x = decade, y = n, fill = vote)
        ) +
          geom_col(width = 6) +
          facet_wrap(~issue) +
          scale_x_continuous(n.breaks = 8) +
          scale_fill_brewer(type = "qual") +
          labs(
            title = glue::glue("How {.y} has voted on six main issues in the UN"),
            subtitle = "#TidyTuesday, 2021-03-23: UN Votes",
            caption = "@jmcastagnetto, Jesus M. Castagnetto",
            x = "",
            y = "",
            fill = "Vote: "
          ) +
          ggthemes::theme_hc(base_size = 18) +
          theme(
            plot.title.position = "plot",
            plot.title = element_text(family = "Ubuntu", size = 34),
            plot.subtitle = element_text(color = "grey50", size = 24),
            plot.caption = element_text(family = "Inconsolata", size = 16),
            plot.margin = unit(rep(.5, 4), "cm")
          )
      }
    ),
    filename = glue::glue("{str_replace_all(str_to_lower(country), ' ', '-')}-un-votes.png")
  )

pwalk(plots_df %>% select(plot, filename),
      ggsave,
      path = "2021-03-23_un-votes/plots/",
      width = 14,
      height = 10)

