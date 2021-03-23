library(tidyverse)

combined_df <- readRDS("2021-03-23_un-votes/combined_df.rds")

#
# grouped_votes <- combined_df %>%
#   group_by(decade, continent, vote) %>%
#   tally()
#
# ggplot(
#   grouped_votes,
#   aes(x = decade, y = n, fill = vote)
# ) +
#   geom_col() +
#   scale_x_continuous(n.breaks = 8) +
#   scale_y_continuous(n.breaks = 7, labels = scales::comma) +
#   scale_fill_brewer(type = "qual") +
#   facet_wrap(~continent, scales = "free_y")
#
#

rcid_per_decade <- combined_df %>%
  filter(!is.na(issue)) %>%
  group_by(decade, issue) %>%
  summarise(
    n_rcid = n_distinct(rcid)
  ) %>%
  ungroup() %>%
  group_by(decade) %>%
  mutate(
    pct = n_rcid / sum(n_rcid)
  )


p1 <- ggplot(
  rcid_per_decade,
  aes(x = decade, y = pct, fill = issue)
) +
  geom_col(width = 10, color = NA) +
  scale_x_continuous(n.breaks = 8) +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_brewer(type = "qual", palette = "Set1") +
  labs(
    x = "",
    y = "Percent of voting calls per issue",
    fill = "Issues:",
    title = "How the relative interest in different issues has changed over time",
    subtitle = "As reflected by voting in the UN (#TidyTuesday, 2021-03-23)",
    caption = "@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  ggthemes::theme_hc(base_size = 18) +
  theme(
    plot.title.position = "plot",
    plot.title = element_text(family = "Ubuntu", size = 34),
    plot.subtitle = element_text(color = "grey50", size = 24),
    plot.caption = element_text(family = "Inconsolata", size = 16),
    plot.margin = unit(rep(.5, 4), "cm")
  )

ggsave(
  plot = p1,
  filename = "2021-03-23_un-votes/plots/un-votes-interest-issues.png",
  width = 16,
  height = 10
)
