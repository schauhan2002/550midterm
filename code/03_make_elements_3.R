# Midterm Report Element #3 (Sakshi)

cleandata <- readRDS(
  file = here::here("data/cleandata.rds")
)

library(gtsummary)
library(ggplot2)

# Table of outcome frequencies and percentages by treatment group 
outcome_table <- cleandata %>%
  select(arm, withdraw2) %>%
  tbl_cross(
    row = arm,
    col = withdraw2,
    percent = "row"
  ) %>%
  bold_labels()
saveRDS(
  outcome_table,
  file = here::here("output/outcome_table.rds")
)

# Bar plot of withdrawal reasons by treatment arm
withdraw_plot <- cleandata %>%
  filter(!is.na(withdraw2)) %>%
  ggplot(aes(x = withdraw2, fill = arm)) +
  geom_bar(position = "dodge") +
  labs(
    x = "Reason for withdrawal",
    y = "Number of patients",
    fill = "Treatment arm",
    title = "Reasons for withdrawal/discontinuation of therapy by treatment arm"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

saveRDS(
  withdraw_plot,
  file = here::here("output/withdraw_plot.rds")
)