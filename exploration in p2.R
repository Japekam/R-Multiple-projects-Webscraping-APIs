library(tidyverse)

csv_file <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vTo1YWxgaYk67TgDdjHUMv15iGKFyyGu3NmsUGtbjZTjRKtB-TEDQdLaF-6pnWbZswYzbT7EK7c53Kb/pub?output=csv"

learning_data <- read_csv(csv_file)%>%
  rename( filling_time = 1,
          age_group = 2,
          total_weekly_consumption = 3,
          favourite_streaming_platform = 4,
          device_used = 5,
          duration_of_content = 6,
          genre = 7)

paste("Last week, the average survey respondent watched content for", mean(learning_data$total_weekly_consumption) %>% round(2), "hours")

paste("The maximum average time spent by an individual watching a single video in a week, as per my survey, is", max(learning_data$duration_of_content), "minutes")

learning_data %>%
  ggplot +
  geom_bar(aes(x = favourite_streaming_platform),
           fill = "#BFF018") +
  labs(title = "Most used streaming platforms", x = "Streaming Platforms", y = "Total number of viewers")

learning_data %>%
  ggplot +
  geom_bar(aes(x = device_used),
           fill = "#F000FF") +
  labs(title = "Most common device used for streaming", x = "Device type", y = "Total number of viewers")
