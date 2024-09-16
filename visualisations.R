library(tidyverse)
library(ggplot2)
library(stringr)

# Read the data from the CSV file
youtube_data <- read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vTANyZ6SGGmp0wDIehlWgpyZ97MHBNPCeyR4TMmqA_s6miASA3CZwhIoIWXgrFsIPrwHsLAIb39Wl_J/pub?output=csv")

# Filter data for Shark Tank India and Shark Tank Global
shark_tank_india <- youtube_data %>%
  filter(channelName == "@SharkTankIndia")

shark_tank_global <- youtube_data %>%
  filter(channelName == "@SharkTankGlobal")

# Calculate average duration for each channel
avg_duration <- youtube_data %>%
  group_by(channelName) %>%
  summarise(avg_duration = mean(duration))

# Create a bar plot for average video duration comparison
avg_duration %>%
  ggplot() +
    geom_bar(aes(x = channelName, y = avg_duration, fill = channelName), 
             stat = "identity", position = "dodge") +
    labs(title = "Average Video Duration Comparison",
        x = "Channel",
        y = "Average Duration (in minutes)") +
    theme_minimal() +
    theme(legend.position = "none")
ggsave("plot1.png", dpi = 100, width = 1200, height = 400, units = "px")

# Calculate engagement rate for each video
youtube_data1 <- youtube_data %>%
  mutate(engagement_rate = (likeCount + commentCount) / viewCount)

# Create a density plot for engagement comparison
youtube_data1 %>%
  ggplot() +
    geom_density(aes(x = engagement_rate, fill = channelName), alpha = 0.5) +
    labs(title = "Engagement Comparison",
        x = "Engagement Rate",
        y = "Density") +
    scale_fill_manual(values = c("@SharkTankIndia" = "blue", "@SharkTankGlobal" = "red")) +
    theme_minimal()
ggsave("plot2.png", dpi = 100, width = 1200, height = 400, units = "px")

# Sort data by likeCount for each channel
top_liked_per_channel <- youtube_data %>%
  group_by(channelName) %>%
  arrange(desc(likeCount))

# Create the histogram
top_liked_per_channel %>%
  ggplot() +
  geom_col(aes(x = reorder(title, likeCount), y = likeCount, fill = channelName), 
           position = "dodge") +
  labs(title = "Top Liked Videos (Shark Tank India vs. Global)",
       x = "video title",  # No x-axis label
       y = "Like Count",
       fill = "Channel")
ggsave("plot3.png", dpi = 100, width = 1200, height = 400, units = "px")

# Number of views per video title length

youtube_data2 <- youtube_data %>%
  mutate(num_words = str_count(title, "\\S+"))

# Filter data for Shark Tank India and Shark Tank Global
shark_tank_india <- youtube_data2 %>%
  filter(channelName == "@SharkTankIndia")

shark_tank_global <- youtube_data2 %>%
  filter(channelName == "@SharkTankGlobal")

# Calculate view count per word of title for each channel
shark_tank_india <- shark_tank_india %>%
  mutate(views_per_word = viewCount / num_words)

shark_tank_global <- shark_tank_global %>%
  mutate(views_per_word = viewCount / num_words)

# Combine the filtered data frames
combined_data <- rbind(shark_tank_india, shark_tank_global)

# Create a scatter plot
combined_data %>%
  ggplot() +
    geom_point(aes(x = num_words, y = views_per_word, color = channelName), size = 3) +
    labs(title = "View Count per Word of Title Comparison",
        x = "Number of Words in Title", y = "Num of Views per Word") +
    scale_color_manual(values = c("@SharkTankIndia" = "blue", "@SharkTankGlobal" = "red"))
ggsave("plot4.png", dpi = 100, width = 1200, height = 400, units = "px")

# Filter for videos with at least 10 likes and 10 views (to avoid division by zero)
youtube_data3 <- youtube_data %>%
  filter(likeCount >= 10 & viewCount >= 10)

# Calculate like-to-view ratio
youtube_data3 <- youtube_data %>%
  mutate(like_view_ratio = likeCount / viewCount)

# Create a histogram
youtube_data3 %>%
  ggplot() +
    geom_histogram(aes(x = like_view_ratio, fill = channelName), bins = 30, color = "black", alpha = 0.7) +
    labs(title = "Distribution of Like to View Ratio",
        x = "Like to View Ratio", y = "Frequency") +
    scale_fill_manual(values = c("@SharkTankIndia" = "skyblue", "@SharkTankGlobal" = "salmon")) +
    theme_minimal()
ggsave("plot5.png", dpi = 100, width = 1200, height = 400, units = "px")
