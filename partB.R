# Load required libraries
library(tidyverse)
library(rvest)

# Selected minister: Hon. Erica Stanford

# 1. Length of words
# PARA 1: Lots of long & fancy words (e.g., "Conference", "Commonwealth").
# PARA 2: A mix of long and short words, some technical ones too (e.g., "initiative").

# 2. Number of words per sentence or paragraph
# PARA 1: Long & complicated sentences, often over 20 words.
# PARA 2: Shorter sentences but still detailed & paragraph length still being similar.

# 3. Frequency of certain words
# PARA 1: Words related to education and government pop up a lot (e.g., "Minister", "conference").
# PARA 2: Words about period products and schools show up frequently (e.g., "period", "schools").

# 4. Use of certain symbols or punctuation
# PARA 1: Lots of commas, quotes, and periods, so it has a pretty complex structure.
# PARA 2: Similar punctuation signs, with lots of quotes and detailed explanstions.

# URL of the minister's page
url <- "https://www.beehive.govt.nz/minister/hon-erica-stanford"

# Scrape the URLs for each release listed on the minister's page
pages <- read_html(url) %>%
  html_elements(".release__wrapper") %>%
  html_elements("h2") %>%
  html_elements("a") %>%
  html_attr("href") %>%
  paste0("https://www.beehive.govt.nz", .)

page_url <- pages[1]

page <- read_html(page_url)

# Scrape the release title
release_title <- page %>%
  html_element("h1") %>%
  html_text2()

# Scrape the release content
release_content <- page %>%
  html_element(".prose") %>%
  html_text2()

# Function to scrape release title and content
get_release <- function(page_url) {
  Sys.sleep(2)
  # print the page_url so if things go wrong
  # we can see which page caused issues
  print(page_url)
  page <- read_html(page_url)
  
  release_title <- page %>%
    html_element("h1") %>%
    html_text2()
  
  release_content <- page %>%
    html_element(".prose") %>%
    html_text2()
  
  tibble(
    release_title = release_title,
    release_content = release_content
  )
}

# Scrape release data
release_data <- map_df(pages, get_release)

# Data manipulations

# Maximum number of words in any release title
max_num_words_title <- release_data$release_title %>%
  str_count("\\w+") %>%
  max()

# Average number of words in the release content
mean_num_words_content <- release_data$release_content %>%
  str_count("\\w+") %>%
  mean()

# Median sentence length in the release content
median_sentence_length <- release_data$release_content %>%
  str_split("\\.\\s+") %>%
  lengths() %>%
  median()

# Ratio of unique words to total words in the release content
unique_words_ratio <- release_data$release_content %>%
  str_split("\\s+") %>%
  unlist() %>%
  unique() %>%
  length() / sum(str_count(release_data$release_content, "\\w+"))

# Count of the word "future" in various forms in the release content
release_data <- release_data %>%
  mutate(future_word_used_count = str_count(release_data$release_content, "future|Future|FUTURE"))

# Total count of the word "future" across all releases
total_future_word_used_count <- release_data$future_word_used_count %>% sum()
