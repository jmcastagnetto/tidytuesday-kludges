library(tidyverse)
load(
  here::here("2019-11-26_us-student-loans/student-loans.Rdata")
)

loans_yq <- loans %>%
#  filter(year != 2015) %>%
  group_by(yq) %>%
  summarise(
    outs = sum(starting, added, na.rm = TRUE),
    cons = sum(consolidation, na.rm = TRUE),
    reha = sum(rehabilitation, na.rm = TRUE),
    volu = sum(voluntary_payments, na.rm = TRUE),
    wage = sum(wage_garnishments, na.rm = TRUE),
    paid = sum(total_calc, na.rm = TRUE),
    unpa = sum(unpaid)
  ) %>%
  mutate(
    pct_paid = paid/outs,
    diff_nxt_qt = lead(outs) - unpa
  ) %>%
  rowwise() %>%
  mutate(
    pct_cons = cons / paid,
    pct_reha = reha / paid,
    pct_volu = volu / paid,
    pct_wage = wage / paid
  ) %>%
  ungroup()

df <- loans_yq %>%
  select(yq, pct_cons, pct_reha, pct_volu, pct_wage) %>%
  pivot_longer(
    cols = 2:5,
    names_to = "payment",
    values_to = "amount"
  ) %>%
  arrange(yq, amount) %>%
  mutate(
    payment = case_when(
      payment == "pct_cons" ~ "Consolidation",
      payment == "pct_reha" ~ "Rehabilitation",
      payment == "pct_volu" ~ "Voluntary Payment",
      payment == "pct_wage" ~ "Wage Garnishments"
    ) %>%
      factor(
        levels = rev(c("Consolidation",
                   "Voluntary Payment",
                   "Rehabilitation",
                   "Wage Garnishments")),
        ordered = TRUE
      )
  )

p1 <- ggplot(df, aes(x = yq, y = amount,
               group = payment, fill = payment)) +
  geom_col(position = position_stack(), color = "grey") +
  geom_text(aes(label = sprintf("%.1f%%", 100*amount)),
            color = "black",
            position = position_stack(vjust = 0.5)) +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(name = "Type of payment",
                    values = c("#FFFACD", "#7FFF00", "#8EE5EE", "#BCEE68")) +
 # guides(fill = guide_legend(nrow = 2, byrow = TRUE)) +
  labs(
    y = "",
    x = "Year/Quarter",
    title = "Payments are dominated by loan consolidation and voluntary repayments",
    subtitle = "Except 2015/4 which shows a bigger fraction due to loan rehabilitation.",
    caption = "#TidyTuesday, 2019-11-26, Student Loans dataset // @jmcastagnetto, Jesus M. Castagnetto"
  ) +
  ggdark::dark_theme_minimal(16) +
  theme(
    plot.margin = unit(rep(1, 4), "cm"),
    legend.position = "top",
    legend.box.spacing = unit(.1, "cm"),
    legend.justification = unit(c(1,1), "npc"),
    axis.title.x = element_text(hjust = 0),
    axis.text.y = element_blank(),
    axis.text.x = element_text(colour = "white")
  )

ggsave(
  p1,
  filename = here::here("2019-11-26_us-student-loans/payment_pct_dist.png"),
  width = 10,
  height = 8
)

p2 <- ggplot(loans_yq, aes(x = yq, y = pct_paid, group = 1)) +
  geom_point(size = 3) +
  geom_line(size = 1.5) +
  geom_segment(aes(xend = yq, yend = .02),
               linetype = "dotted") +
  ggrepel::geom_label_repel(
    aes(label = sprintf("%.1f%%", 100*pct_paid)),
    size = 8, label.size = 0, color = "yellow", alpha = 0.8) +
  scale_y_continuous(labels = scales::percent,
                     limits = c(.02, NA)) +
  labs(
    y = "Percent of debt repaid",
    y = "",
    x = "Year/Quarter",
    title = "Total payments are a small fraction of the oustanding debt",
    subtitle = "So it takes a very long time to get rid of this obligation",
    caption = "#TidyTuesday, 2019-11-26, Student Loans dataset // @jmcastagnetto, Jesus M. Castagnetto"
  ) +
  ggdark::dark_theme_minimal(16) +
  theme(
    plot.margin = unit(rep(1, 4), "cm"),
    axis.text.y = element_blank(),
    axis.title.x = element_text(hjust = 0),
    axis.text.x = element_text(colour = "white")
  )

ggsave(
  p2,
  filename = here::here("2019-11-26_us-student-loans/pct_paid_yq.png"),
  width = 10,
  height = 7
)
