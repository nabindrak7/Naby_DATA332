# Load necessary libraries
library(readxl)
library(dplyr)
library(ggplot2)
library(lubridate)

# Load the data
billing <- read_excel("C:/Users/nabin/OneDrive/Documents/r_projects/Patient_Billing/Billing.xlsx")
patient <- read_excel("C:/Users/nabin/OneDrive/Documents/r_projects/Patient_Billing/Patient.xlsx")
visit <- read.csv("C:/Users/nabin/OneDrive/Documents/r_projects/Patient_Billing/Visit.txt", header = FALSE, col.names = c("VisitID", "PatientID", "VisitDate", "Reason", "WalkIn"))

# Convert VisitID and PatientID to character in all datasets
billing$VisitID <- as.character(billing$VisitID)
visit$VisitID <- as.character(visit$VisitID)
visit$PatientID <- as.character(visit$PatientID)
patient$PatientID <- as.character(patient$PatientID)

# Convert VisitDate to Date format
visit$VisitDate <- as.Date(visit$VisitDate, format = "%m/%d/%Y")

# Join the data
data <- billing %>%
  left_join(visit, by = "VisitID") %>%
  left_join(patient, by = "PatientID")

# Extract month from VisitDate
data$Month <- month(data$VisitDate, label = TRUE, abbr = TRUE)

# Insight 1: Reason for Visit by Month (Stacked Bar Chart)
ggplot(data, aes(x = Month, fill = Reason)) +
  geom_bar(position = "stack") +
  labs(title = "Reason for Visit by Month", x = "Month", y = "Number of Visits") +
  theme_minimal()

# Insight 2: Reason for Visit by Walk-In Status
ggplot(data, aes(x = WalkIn, fill = Reason)) +
  geom_bar(position = "stack") +
  labs(title = "Reason for Visit by Walk-In Status", x = "Walk-In", y = "Number of Visits") +
  theme_minimal()

# Insight 3: Reason for Visit by City
ggplot(data, aes(x = City, fill = Reason)) +
  geom_bar(position = "stack") +
  labs(title = "Reason for Visit by City", x = "City", y = "Number of Visits") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Insight 4: Total Invoice Amount by Reason (Stacked Bar Chart)
ggplot(data, aes(x = Reason, y = InvoiceAmt, fill = InvoicePaid)) +
  geom_bar(stat = "summary", fun = "sum", position = "stack") +
  labs(title = "Total Invoice Amount by Reason", x = "Reason", y = "Total Invoice Amount") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Insight 5: Most Common Reason for Visits in Atlanta
atlanta_data <- data %>% filter(City == "Atlanta")
ggplot(atlanta_data, aes(x = reorder(Reason, -table(Reason)[Reason]))) +
  geom_bar(fill = "steelblue") +
  labs(title = "Most Common Reason for Visits in Atlanta", x = "Reason", y = "Number of Visits") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Save the plots
ggsave("reason_by_month.png", width = 10, height = 6)
ggsave("reason_by_walkin.png", width = 10, height = 6)
ggsave("reason_by_city.png", width = 10, height = 6)
ggsave("invoice_by_reason.png", width = 10, height = 6)
ggsave("common_reason_atlanta.png", width = 10, height = 6)