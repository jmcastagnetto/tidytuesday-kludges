library(tidyverse)
library(ggridges)
library(ggdark)

load(
  here::here("2020-01-14_passwords",
             "passwords-dataset.Rdata")
)

# table(passwords$rank == passwords$rank_alt)
#
# table(passwords$category, useNA = "ifany")
#
# table(passwords$strength)
# table(passwords$strength_capped)

## ridgeplots

#--- entropy by class
ggplot(passwords,
       aes(x = entropy, y = category,
           fill = category)) +
  geom_density_ridges(show.legend = FALSE) +
  labs(
    y = "",
    x = "Entropy (in bits)",
    title = "The entropy distribution changes for each password class\nbut all are below de 64 bits ideal value.",
    subtitle = "Inspired by https://twitter.com/DaveBloom11/status/1217568434885734401",
    caption = "#TidyTuesday, 2020-01-14: passwords dataset // @jmcastagnetto, Jesús M. Castagnetto"
  ) +
  dark_theme_minimal(18) +
  theme(
    plot.margin = unit(rep(1, 4), "cm"),
  )

ggsave(
  filename = here::here(
    "2020-01-14_passwords",
    "password-entropy-by-class-ridges.png"
  ),
  width = 12,
  height = 9
)

#--- Capped strength by class
ggplot(passwords,
       aes(x = strength_capped, y = category,
           fill = category)) +
  geom_density_ridges(show.legend = FALSE) +
  labs(
    y = "",
    x = "Password strentgh (capped to the [0, 10] range)",
    title = "Passwords strengths are very bad for some classes",
    subtitle = "Simple alphanumeric passwords are the weakest,\nbut food related passwords are not that great either.",
    caption = "#TidyTuesday, 2020-01-14: passwords dataset // @jmcastagnetto, Jesús M. Castagnetto"
  ) +
  dark_theme_minimal(18) +
  theme(
    plot.margin = unit(rep(1, 4), "cm"),
  )

ggsave(
  filename = here::here(
    "2020-01-14_passwords",
    "password-stength-by-class-ridges.png"
  ),
  width = 12,
  height = 9
)


#-- offline cracking times
ggplot(passwords, aes(x = offline_crack_sec, y = category, fill = category)) +
  ggridges::geom_density_ridges(show.legend = FALSE) +
  scale_x_log10() +
  annotation_logticks(sides = "b", color = "white") +
  labs(
    y = "",
    x = "Offline cracking time",
    title = "Alphanumeric passwords can be cracked faster",
    subtitle = paste0("But the maximum estimated time to crack them offline in less than ", ceiling(max(passwords$offline_crack_sec)), " seconds."),
    caption = "#TidyTuesday, 2020-01-14: passwords dataset // @jmcastagnetto, Jesús M. Castagnetto"
  ) +
  dark_theme_minimal(18) +
  theme(
    plot.margin = unit(rep(1, 4), "cm"),
  )

ggsave(
  filename = here::here(
    "2020-01-14_passwords",
    "password-offline-cracking-times-by-class-ridges.png"
  ),
  width = 12,
  height = 9
)

#--- online cracking times
years_seconds <- days_seconds * 365.25

ggplot(passwords, aes(x = online_crack_sec, y = category, fill = category)) +
  ggridges::geom_density_ridges(show.legend = FALSE) +
  scale_x_log10() +
  annotation_logticks(sides = "b", color = "white") +
  labs(
    y = "",
    x = "Online cracking time",
    title = "Online cracking times by class are longer",
    subtitle = paste0("For online cracking, the maximum estimated time to crack them is up to ", ceiling(max(passwords$online_crack_sec / years_seconds)), " years."),
    caption = "#TidyTuesday, 2020-01-14: passwords dataset // @jmcastagnetto, Jesús M. Castagnetto"
  ) +
  dark_theme_minimal(18) +
  theme(
    plot.margin = unit(rep(1, 4), "cm"),
  )

ggsave(
  filename = here::here(
    "2020-01-14_passwords",
    "password-online-cracking-times-by-class-ridges.png"
  ),
  width = 12,
  height = 9
)

#--- models just for fun, maybe I'll do something with them later (or maybe not)


model <- glm(strength_capped ~ n_nums + n_alpha + category + entropy, passwords, family = "gaussian")

model <- glm(strength_capped ~ n_alpha + n_nums, passwords, family = "gaussian")


model <- glm(offline_crack_sec ~ n_nums + n_alpha, passwords, family = "gaussian")

model <- glm(online_crack_sec ~ n_nums + n_alpha, passwords, family = "gaussian")

ggplot(passwords, aes(online_crack_sec, offline_crack_sec)) +
  geom_point() +
  scale_y_log10() +
  scale_x_log10()
