# Trying a LASSO model
library(tidyverse)
library(ggdark)
library(showtext)
library(recipes)
library(glmnet)

load(
  here::here("2019-10-08_international-powerlifting/ipf.Rdata")
)

# prepare the data
df <- athlete_trajectory %>%
  filter(!is.na(bodyweight_kg) & !is.na(weight_lifted)) %>%
  select(weight_lifted,
         age, sex, equipment, bodyweight_kg, n, weightlifting_type)

# make the recipe to onehotencode
rec <- recipe(weight_lifted ~ ., data = df) %>%
  step_dummy(sex, equipment, weightlifting_type, one_hot = TRUE)

# apply onehot encoding
df_recoded <- rec %>%
  prep() %>%
  juice()

# pick the rows to use for training
set.seed(20191008)
n_regs <- nrow(df_recoded)
train_idx <- sample(1:n_regs, floor(0.7*n_regs))

# extract the training data
y_train <- df_recoded %>%
  slice(train_idx) %>%
  pluck("weight_lifted")
x_train <- df_recoded %>%
  slice(train_idx) %>%
  select(-weight_lifted) %>%
  as.matrix()

# and the test data
y_test <- df_recoded %>%
  slice(-train_idx) %>%
  pluck("weight_lifted")
x_test <- df_recoded %>%
  slice(-train_idx) %>%
  select(-weight_lifted) %>%
  as.matrix()

# run the model
lasso_model <- glmnet(x_train, y_train, alpha = 1)
# plot(lasso_model, xvar = "lambda")
# legend("bottomright", lwd = 1, col = 1:6,
#        legend = colnames(x_train), cex = .7)

# use CV to get the best lambda
cv_lasso_model <- cv.glmnet(x_train, y_train)
# plot(cv_lasso_model)
# the min lambda looks like a good choice

y_pred <- predict(lasso_model, x_test,
                  s = cv_lasso_model$lambda.min)
# cor(y_test, y_pred)
# [1,] 0.8825869

# for the plot, apply the prediction to all the data
y_pred_all <- predict(lasso_model,
                      df_recoded %>%
                        select(-weight_lifted) %>%
                        as.matrix(),
                      s = cv_lasso_model$lambda.min)

# generate a data frame to plot this results
df_recoded_pred <- df_recoded %>%
  bind_cols(
    pred_wl = y_pred_all[, "1"]
  ) %>%
  pivot_longer(
    cols = c(sex_Female, sex_Male),
    names_to = "gender",
    names_prefix = "sex_",
    values_to = "dummy"
  ) %>%
  filter(
    dummy == 1
  ) %>%
  select(-dummy) %>%
  pivot_longer(
    cols = c(equipment_Raw, equipment_Single.ply, equipment_Wraps),
    names_to = "equipment",
    names_prefix = "equipment_",
    values_to = "dummy"
  ) %>%
  filter(
    dummy == 1
  ) %>%
  select(-dummy) %>%
  pivot_longer(
    cols = c(weightlifting_type_Bench,
             weightlifting_type_Deadlift,
             weightlifting_type_Squat),
    names_to = "weightlifting_type",
    names_prefix = "weightlifting_type_",
    values_to = "dummy"
  ) %>%
  filter(
    dummy == 1
  ) %>%
  select(-dummy)

# make a hex plot

font_add_google("Special Elite", "sp_elite")
font_add_google("Inconsolata", "inconsolata")

showtext_auto(TRUE)

custom_theme_opt <- dark_theme_light() +
  theme(
    axis.title = element_text(size = 18),
    axis.text = element_text(size = 14),
    strip.text = element_text(color = "yellow", size = 20),
    plot.title = element_text(family="sp_elite", size = 42),
    plot.subtitle = element_text(family="sp_elite", size = 32),
    plot.caption = element_text(family = "inconsolata", size = 18),
    plot.margin = unit(rep(1, 4), "cm")
  )

caption_str <- "#TidyTueday, International Powerlifting, 2019-10-08 // @jmcastagnetto, Jesus M. Castagnetto"

summ_corr <- df_recoded_pred %>%
  group_by(weightlifting_type, gender) %>%
  summarise(
    n = n(),
    na_pred = sum(is.na(pred_wl)),
    cor = cor(weight_lifted, pred_wl, use = "complete.obs")
  ) %>%
  mutate(
    label = paste("corr=", round(cor, 2))
  )

lasso_plot <- ggplot(df_recoded_pred,
       aes(x = weight_lifted, y = pred_wl, group = gender)) +
  geom_abline(slope = 1, intercept = 0, color = "white", alpha = 0.3, size = 0.2) +
  geom_hex(bins = 30, na.rm = TRUE) +
  geom_text(data = summ_corr, aes(label = label),
            x = 450, y = 200, hjust = 0, color = "white") +
  ylim(0, 500) +
  labs(
    title = "Predicted vs actual weight lifted by athletes",
    subtitle = "Using LASSO. Shown grouped by gender and weighlifting type.",
    caption = caption_str,
    x = "Weight Lifted (kg)",
    y = "Predicted value (kg)"
  ) +
  scale_fill_viridis_c(name = "", option = "plasma", guide = "colorbar") +
  facet_grid(weightlifting_type~gender) +
  custom_theme_opt +
  guides(fill = guide_colorbar(draw.llim = TRUE, draw.ulim = TRUE,
                               barheight = unit(5, "cm")))

ggsave(
  plot = lasso_plot,
  filename = here::here("2019-10-08_international-powerlifting/lasso_model_weightlifted_predicted.png"),
  width = 8,
  height = 6
)

