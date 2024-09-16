library(tidyverse)
library(rvest)

# My data context is the global health metrics provided by the WHO
# Information from webpages that might be useful to scrape includes country profiles, health indicators, and regional health statistics.

# The website I chose to scrape data from is the World Health Organization (WHO) data collection tools page.
# URL: https://www.who.int/data/data-collection-tools/score/country-profiles
# This site allows scraping as it doesn't prohibit it in its robots.txt file and terms/conditions for data use. So it is appropriate for webscraping

# Assign the URL of the webpage to scrape
url <- "https://www.who.int/data/data-collection-tools/score/country-profiles"

# Read the HTML content from the webpage
page <- read_html(url)

# Scrape the main heading from the webpage using the <h1> HTML element
main_heading <- page %>%
  html_elements("h1") %>%
  html_text2()

# Scrape the footer information from the webpage using the <h2> HTML element
footer <- page %>%
  html_elements("h2") %>%
  html_text2()

# Scrape the list of countries linked on the webpage
WHO_countries <- page %>%
  html_elements(".arrowed-link") %>%
  html_text2()

# Scrape the section headings on the webpage
regions <- page %>%
  html_elements(".section-heading") %>%
  html_text2()

# Clean up the scraped region data by removing any extra characters
regions <- str_remove_all(regions, "\r")

# Output the values of the data objects
main_heading
footer
WHO_countries
regions
