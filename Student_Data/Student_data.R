# Load necessary libraries
library(readxl)
library(dplyr)
library(ggplot2)

# Define file paths
student_file <- "C:/Users/nabin/OneDrive/Documents/r_projects/Student.xlsx"
registration_file <- "C:/Users/nabin/OneDrive/Documents/r_projects/Registration.xlsx"
course_file <- "C:/Users/nabin/OneDrive/Documents/r_projects/Course.xlsx"

# Read Excel files
student_data <- read_excel(student_file)
registration_data <- read_excel(registration_file)
course_data <- read_excel(course_file)

# Standardize column names: Convert to lowercase and remove spaces
clean_names <- function(df) {
  colnames(df) <- tolower(gsub("\\s+", "_", colnames(df))) # Convert spaces to underscores
  return(df)
}

student_data <- clean_names(student_data)
registration_data <- clean_names(registration_data)
course_data <- clean_names(course_data)

# Print cleaned column names
print("Cleaned Column Names in Student Data:")
print(colnames(student_data))

print("Cleaned Column Names in Registration Data:")
print(colnames(registration_data))

print("Cleaned Column Names in Course Data:")
print(colnames(course_data))

# Perform left joins using the correct column names
merged_data <- student_data %>%
  left_join(registration_data, by = "student_id") %>%
  left_join(course_data, by = "instance_id")

# Check if the merge was successful
print("First few rows of merged data:")
print(head(merged_data))

# Chart 1: Number of students per course title (TITLE)
student_count_per_course <- merged_data %>%
  group_by(title) %>%
  summarise(student_count = n())

ggplot(student_count_per_course, aes(x = title, y = student_count, group = 1)) +
  geom_line(color = "steelblue", size = 1) +
  geom_point(color = "steelblue", size = 2) +
  theme_minimal() +
  labs(title = "Number of Students per Course", x = "Course Title", y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Chart 2: Number of students by birth year
merged_data$birth_year <- format(as.Date(merged_data$birth_date, format = "%Y-%m-%d"), "%Y")

student_count_by_birth_year <- merged_data %>%
  group_by(birth_year) %>%
  summarise(student_count = n())

ggplot(student_count_by_birth_year, aes(x = birth_year, y = student_count, group = 1)) +
  geom_line(color = "darkgreen", size = 1) +
  geom_point(color = "darkgreen", size = 2) +
  theme_minimal() +
  labs(title = "Number of Students by Birth Year", x = "Birth Year", y = "Count")

# Chart 3: Total cost per course title, segmented by payment plan
total_cost <- merged_data %>%
  group_by(title, payment_plan) %>%
  summarise(total_cost = sum(total_cost, na.rm = TRUE))

ggplot(total_cost, aes(x = title, y = total_cost, color = payment_plan, group = payment_plan)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  theme_minimal() +
  labs(title = "Total Cost per Course Title, Segmented by Payment Plan", x = "Course Title", y = "Total Cost") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Chart 4: Total balance due per course title, segmented by payment plan
total_balance <- merged_data %>%
  group_by(title, payment_plan) %>%
  summarise(total_balance_due = sum(balance_due, na.rm = TRUE))

ggplot(total_balance, aes(x = title, y = total_balance_due, color = payment_plan, group = payment_plan)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  theme_minimal() +
  labs(title = "Total Balance Due per Course Title, Segmented by Payment Plan", x = "Course Title", y = "Total Balance Due") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Insights
print("Insights:")
# Insight 1: Course with the highest enrollment
most_popular_course <- student_count_per_course %>%
  arrange(desc(student_count)) %>%
  slice(1)
print(paste("The course with the highest enrollment is:", most_popular_course$title, "with", most_popular_course$student_count, "students."))

# Insight 2: Most common birth year
most_common_birth_year <- student_count_by_birth_year %>%
  arrange(desc(student_count)) %>%
  slice(1)
print(paste("The most common birth year among students is:", most_common_birth_year$birth_year, "with", most_common_birth_year$student_count, "students."))

# Insight 3: Total cost and balance due trends
print("Total cost and balance due trends per course and payment plan have been visualized.")