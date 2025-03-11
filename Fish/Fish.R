# Load libraries
library(ggplot2)
library(dplyr)
library(tidyverse)
library(readxl)
library(tidyr)
library(here)
library(kableExtra)

# Set up dynamic file paths using the `here` package
# Absolute file paths (if not in 'data' folder)
kelp_fronds <- "C:/Users/nabin/OneDrive/Documents/r_projects/Fish/kelp_fronds.xlsx"
fish_file <- "C:/Users/nabin/OneDrive/Documents/r_projects/Fish/fish.csv"

# Read in data
fish <- read_csv(fish_file)  # Or use here() if file is in the 'data' subfolder
kelp_abur <- read_excel(kelp_fronds, sheet = "abur")  # Or use here() if file is in the 'data' subfolder

# Filtering examples
fish_garibaldi <- fish %>%
  filter(common_name == "garibaldi")

fish_mohk <- fish %>%
  filter(site == "mohk")

fish_over50 <- fish %>%
  filter(total_count >= 50)

fish_3sp <- fish %>%
  filter(common_name %in% c("garibaldi", "blacksmith", "black surfperch"))

fish_gar_2016 <- fish %>%
  filter(year == 2016 | common_name == "garibaldi")

aque_2018 <- fish %>%
  filter(year == 2018, site == "aque")

# Sequential filtering
aque_2018 <- fish %>% 
  filter(year == 2018) %>% 
  filter(site == "aque")

# Filter with multiple conditions
low_gb_wr <- fish %>% 
  filter(common_name %in% c("garibaldi", "rock wrasse"), 
         total_count <= 10)

# Filter using string detection
fish_bl <- fish %>% 
  filter(str_detect(common_name, pattern = "black"))

fish_it <- fish %>% 
  filter(str_detect(common_name, pattern = "it"))

# Joining examples
abur_kelp_fish <- kelp_abur %>% 
  full_join(fish, by = c("year", "site"))

kelp_fish_left <- kelp_abur %>% 
  left_join(fish, by = c("year", "site"))

kelp_fish_injoin <- kelp_abur %>% 
  inner_join(fish, by = c("year", "site"))

# Create a new variable using mutate
my_fish_join <- fish %>% 
  filter(year == 2017, site == "abur") %>% 
  left_join(kelp_abur, by = c("year", "site")) %>% 
  mutate(fish_per_frond = total_count / total_fronds)

# Format and display the table
my_fish_join %>% 
  kable() %>% 
  kable_styling(bootstrap_options = "striped", full_width = FALSE)

# Right join example
kelp_fish_right <- kelp_abur %>% 
  right_join(fish, by = c("year", "site"))

kable(kelp_fish_right) %>% 
  kable_styling(bootstrap_options = "striped", full_width = FALSE)

# Semi join example
kelp_fish_semi <- kelp_abur %>% 
  semi_join(fish, by = c("year", "site"))

kable(kelp_fish_semi) %>% 
  kable_styling(bootstrap_options = "striped", full_width = FALSE)

# Cross join example
kelp_fish_cross <- kelp_abur %>% 
  cross_join(fish)

kable(head(kelp_fish_cross)) %>% 
  kable_styling(bootstrap_options = "striped", full_width = FALSE)

# Visualization example: Fish count vs. Kelp fronds
ggplot(my_fish_join, aes(x = total_fronds, y = total_count, color = common_name)) +
  geom_point(size = 3, alpha = 0.7) +
  labs(title = "Fish Count vs. Kelp Fronds",
       x = "Total Fronds",
       y = "Total Fish Count",
       color = "Common Name") +
  theme_minimal() +
  theme(legend.position = "bottom")


# Stacked Bar Chart: Total Fish Count by Species for Each Site
ggplot(fish, aes(x = site, y = total_count, fill = common_name)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Total Fish Count by Species for Each Site",
       x = "Site",
       y = "Total Fish Count",
       fill = "Common Name") +
  theme_minimal() +
  theme(legend.position = "bottom",
        axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for better readability