library(tidyverse)
library(rvest)
library(ggplot2)

# Define the keywords to search for in the speeches
keywords <- c("employment", "environment", "economy")

# Scrape and process speech data for the first keyword
search1 <- read_html(paste0("https://datalandscapes.online/scrapeable/speeches.php?search=", keywords[1])) %>%
  html_elements(".speech_summary") %>%
  html_text2() %>%
  tibble(keyword = keywords[1], results = .) %>%
  separate(results, into = c("year", "num_speeches"), sep = "--") %>%
  mutate(num_speeches = parse_number(num_speeches), year = parse_number(year))

# Scrape and process speech data for the second keyword
search2 <- read_html(paste0("https://datalandscapes.online/scrapeable/speeches.php?search=", keywords[2])) %>%
  html_elements(".speech_summary") %>%
  html_text2() %>%
  tibble(keyword = keywords[2], results = .) %>%
  separate(results, into = c("year", "num_speeches"), sep = "--") %>%
  mutate(num_speeches = parse_number(num_speeches), year = parse_number(year))

# Scrape and process speech data for the third keyword
search3 <- read_html(paste0("https://datalandscapes.online/scrapeable/speeches.php?search=", keywords[3])) %>%
  html_elements(".speech_summary") %>%
  html_text2() %>%
  tibble(keyword = keywords[3], results = .) %>%
  separate(results, into = c("year", "num_speeches"), sep = "--") %>%
  mutate(num_speeches = parse_number(num_speeches), year = parse_number(year))

# Combine the individual search data frames into one
combined_search <- bind_rows(search1, search2, search3)

# Load the government speeches data from the Google sheet
speeches_governments <- read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vRHTFJcFmsIkjaFUCEwFWASaBOAR4X2Upx66C5Bhgc_WNc2JxxdRbbvyoewmvt_EjNdCNZZzzkENwLg/pub?gid=0&single=true&output=csv")

# Join the combined search data with the government speeches data by year
speech_data <- left_join(combined_search, speeches_governments, by = "year")

# Prepare the data for plotting
plot_data <- speech_data %>%
  group_by(keyword, year) %>%
  summarise(speech_ratio = (num_speeches/total_speeches))

# Create a bargraph using ggplot2
final_plot <- plot_data %>%
  ggplot() +
  geom_bar(aes(x = year, y = speech_ratio, fill = keyword), stat = "identity", position = "dodge") +
  labs(title = "Ratio of speeches with the keyword by total number of speeches, compared yearly",
       caption = "The bigger the bar, the higher the percentage of speeches with the keyword!",
       x = "Year",
       y = "Speech Ratio",
       fill = "Keyword") +
  theme_minimal() +
  theme(legend.position = "top")

final_plot
