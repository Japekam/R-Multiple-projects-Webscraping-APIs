library(tidyverse)
library(jsonlite)
library(magick)

# Read the data from the JSON file
json_data <- fromJSON("pixabay_data.json")

# Extract the data about individual photos into a data frame called pixabay_photo_data
pixabay_photo_data <- json_data$hits

# Manipulate the data frame pixabay_photo_data to create a new data frame called selected_photos
selected_photos <- pixabay_photo_data %>%
  # Selecting only some of the variables from pixabay_photo_data
  select(previewURL, pageURL, id, user_id, user, likes, views, downloads, tags) %>%
  # Creating three NEW variables
  mutate(category = ifelse(likes <= 15, "low", "high")) %>% # Categorical variable with 2 level
  # Other two numerical variables
  mutate(likes_per_view = likes / views) %>%
  mutate(download_ratio = downloads / views) %>%
  # Filtering to select only some of the photos
  filter(views > 2700 & views < 7000)

# Save the data frame selected_photos as a CSV file to your project folder
write_csv(selected_photos, "selected_photos.csv")

# Calculate the median number of likes for the selected photos, rounding the result
median_likes <- selected_photos$likes %>% median(na.rm = TRUE) %>% round()

# Find the maximum number of views among the selected photos
max_views <- selected_photos$views %>% max(na.rm = TRUE)

# Calculate the total number of downloads for the selected photos
total_downloads <- selected_photos$downloads %>% sum(na.rm = TRUE)

# Find the minimum number of views among the selected photos
min_views <- selected_photos$views %>% min(na.rm = TRUE)

# Group the selected photos by category and summarize the median likes per view and median download ratio for each category
summary_by_category <- selected_photos %>%
  group_by(category) %>%
  summarise(median_likes_per_view = median(likes_per_view, na.rm = TRUE),
            median_download_ratio = median(download_ratio, na.rm = TRUE))

# Read the selected photos' preview URLs, scale, resize, morph, and create an animated GIF
animated_images <- image_read(selected_photos$previewURL) %>%
  image_scale(350) %>%
  image_resize('300x250!') %>%
  image_morph() %>%
  image_animate(optimize = TRUE, fps = 25)

# Write the animated images to a GIF file
image_write(animated_images, "my_photos.gif")

# Create a bar plot of download ratio by category using ggplot
ggplot(selected_photos, aes(x = category, y = download_ratio, fill = category)) +
  geom_bar(stat = "identity", position = "dodge") +  # Display bars side-by-side
  labs(title = "Download Ratio by Category",
       x = "Category",
       y = "Download Ratio",
       fill = "Category")