library(tidyverse)
library(ggstatsplot)

divorce_margarine <- structure(
    list(
      divorce_rate_maine =
        c(
          0.005, 0.0047, 0.0046, 0.0044, 0.0043,
          0.0041, 0.0042, 0.0042, 0.0042, 0.0041
        ),
      margarine_consumption_per_capita =
        c(8.2, 7, 6.5, 5.3, 5.2,
          4, 4.6, 4.5, 4.2, 3.7),
      year = 2000:2009
    ),
    row.names = c(NA, -10L),
    class = "data.frame"
  )

df <- divorce_margarine %>%
  rename(
    divorce = divorce_rate_maine,
    Margarine = margarine_consumption_per_capita
  ) %>%
  mutate(
    divorce = divorce * 1000, # rate per thousand
    year = factor(year)
  )

# Ref: https://www.ers.usda.gov/webdocs/DataFiles/48685/pcconsp_1_.xlsx?v=1572
df <- bind_cols(
  df,
  data.frame(
    Butter = c(
      4.5, 4.3, 4.4, 4.5, 4.5,
      4.5, 4.7, 4.7, 5.0, 5.0
    )
  )
) %>%
  pivot_longer(
    cols = c(Margarine, Butter),
    names_to = "product",
    values_to = "amount"
  )


ggplot(df, aes(amount, divorce, color = product)) +
  geom_point(show.legend = FALSE) +
  geom_smooth(method = "lm", show.legend = FALSE) +
  facet_wrap(~product, scales = "free")

ggscatterstats(
  data = df,
  x = product,
  y = divorce,
  xlab = "Dairy product consumption per capita (lbs)",
  ylab = "Divorce rate in Maine (per 1,000)",
  title = "Spurious Correlation",
  marginal = FALSE,
  bf.message = FALSE,
  method = "lm",
  formula = y ~ x,
  results.subtitle = FALSE,
  line.size = 1,
  point.alpha = 1,
  point.size = 3
)

library(ggpubr)
ggscatter(
  data = df,
  x = "amount",
  y = "divorce",
  color = "product",
  xlab = "Dairy product consumption per capita (lbs)",
  ylab = "Divorce rate in Maine (per 1,000)",
  title = "Spurious Correlation (https://www.tylervigen.com/spurious-correlations)",
  subtitle = "What? The more margarine is consumed the higher the divorce rate!!! 😏"\nI knew that those \"I can't believe is not butter\" ads were a hiding something...\n∴ Q.E.D: Butter is healthier for your marriage 😋"
  add = "reg.line",
  add.params = list(color = "b"blue", ll = "darkgray"),
  conf.int = TRUE,
  caption = "#TData sources: National Vital Statistics Reports and U.S. Deparment of Agriculture\nidyTuesday 2019-12-10: Replicating plots in R\n // mcastagnetto, Jesús M. Castagnetto"
) +
  stat_cor(
    aes(
      label = paste0(..rr.label.., "~~~",
                    ..p.label..)
    ),
    label.x =.npc = .1    size = 6
  ) +
  theme_pubr(16) +
  theme(
    pllegend.position = "none",
    ot.title = element_text(face = "bold")
 ,
    axis.line.y.left = element_blank(), )
  panel.grid.major.y = element_line(color = "gray")
   +
  facet_wrap(~product, scales = "free_x")