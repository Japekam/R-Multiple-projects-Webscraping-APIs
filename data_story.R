library(magick)

my_colors <- c("lightblue", "lightgreen", "lightpink", "white", "lightgrey", "lightcoral", "lightyellow")

# Title slide
title_slide <- image_blank(color = my_colors[1], width = 1200, height = 400) %>%
  image_annotate(text = "Here's my Presentation Sharks", size = 50, gravity = "center")

# Visualization slides
plot1_slide <- image_read("plot1.png") %>%
  image_background(color = my_colors[2])

plot2_slide <- image_read("plot2.png") %>%
  image_background(color = my_colors[3])

plot3_slide <- image_read("plot3.png") %>%
  image_background(color = my_colors[4])

plot4_slide <- image_read("plot4.png") %>%
  image_background(color = my_colors[5])

plot5_slide <- image_read("plot5.png") %>%
  image_background(color = my_colors[6])

# Conclusion slide
conclusion_text <- "Overall, I learned that Shark Tank Global posts longer video on average compared to the Indian one. Their engagement ratio is far less than that of Shark Tank India. Most liked videos of Shark Tank India outnumbered the most liked video of Shark Tank global by a big margin. Shark Tank India sees a better result if they post more number of words in their title." %>%
  str_wrap(66)

conclusion_slide <- image_blank(color = my_colors[7], width = 1200, height = 400) %>%
  image_annotate(text = conclusion_text, size = 40, gravity = "center")

# Combine slides
frames <- c(rep(title_slide, 5), rep(plot1_slide, 5), rep(plot2_slide, 5), rep(plot3_slide, 5), rep(plot4_slide, 5), rep(plot5_slide, 5), rep(conclusion_slide, 5))
dynamic_data_story <- image_animate(frames, fps = 1)

image_write(dynamic_data_story, "data_story.gif")
