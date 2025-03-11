Patient Billing Analysis
Overview
This project focuses on analyzing patient billing data to uncover insights into patient visits, reasons for visits, and billing trends. The analysis involves joining datasets, creating visualizations, and summarizing key findings to understand patterns in patient visits and billing.

Datasets
Billing.xlsx
Contains billing information, including invoice numbers, visit IDs, invoice amounts, and payment status.

Patient.xlsx
Contains patient information, including patient IDs, names, addresses, cities, states, and zip codes.

Visit.txt
Contains visit information, including visit IDs, patient IDs, visit dates, reasons for visits, and walk-in status.

Libraries Used
ggplot2 - For creating data visualizations.

dplyr - For data manipulation and filtering.

readxl - For reading Excel files.

lubridate - For handling date-time data.

Key Features
Data Filtering
Filtered data by specific cities, reasons for visits, and payment status.

Applied numeric conditions to filter invoices based on amounts.

Data Joining
Joined Billing, Patient, and Visit datasets using relational keys (VisitID and PatientID).

Used left_join to combine all records while preserving the structure of the billing data.

Data Wrangling Sequence
Converted VisitID and PatientID to character type for consistency.

Converted VisitDate to a proper date format.

Extracted the month from VisitDate for monthly analysis.

Visualizations and Tables
Created stacked bar charts, bar plots, and summary tables to visualize insights.

Saved visualizations as PNG files for documentation.

Insights
1. Reason for Visit by Month (Stacked Bar Chart)
Reason by Month

Insight: The stacked bar chart shows the distribution of reasons for visits across different months.

Observation: Influenza peaks during colder months (e.g., October, November), while wellness visits are consistent throughout the year.

Conclusion: Seasonal illnesses like Influenza drive higher visit volumes in specific months.
![41fc2701-0de3-4d98-b2b5-2891deaba907](https://github.com/user-attachments/assets/c0f41f35-b3cb-46fa-bae7-404f7d154a34)


2. Reason for Visit by Walk-In Status
Reason by Walk-In

Insight: This visualization compares reasons for visits between walk-in and scheduled appointments.

Observation: Walk-in visits are more common for acute conditions like Influenza and Dermatitis, while scheduled visits are more common for wellness checks and chronic condition management.

Conclusion: Walk-in visits are often driven by urgent or acute health issues.

![a19e7a5f-4d5f-4f49-b890-1412ba03683f](https://github.com/user-attachments/assets/f732566b-5a5b-49fc-b7f7-026390e109ca)


3. Reason for Visit by City
Reason by City

Insight: This chart shows the distribution of reasons for visits across different cities.

Observation: Cities like Atlanta and Marietta have higher visit volumes for Dermatitis and Influenza, while smaller cities like Conley have fewer visits overall.

Conclusion: Urban areas with larger populations tend to have higher visit volumes for common conditions.
![e34dbcb0-d019-471a-a213-9fb635581428](https://github.com/user-attachments/assets/a0c27763-f4c0-4ae2-acba-6b2c21ce11fd)



4. Total Invoice Amount by Reason (Stacked Bar Chart)
Invoice by Reason

Insight: This visualization shows the total invoice amounts segmented by reason for visit and payment status.

Observation: Procedures like Minor Surgery and Radiographs have the highest invoice amounts. Paid invoices are more common for routine visits, while unpaid invoices are often associated with higher-cost procedures.

Conclusion: Higher-cost procedures are more likely to have unpaid invoices, indicating potential billing challenges for specialized services.


![574930c6-a547-42a1-a708-2c5937e4ec0c](https://github.com/user-attachments/assets/3dbc2fa3-9ed9-43d3-af17-1264eedb4a30)

5. Most Common Reason for Visits in Atlanta
Common Reason in Atlanta

Insight: This bar chart highlights the most common reasons for visits in Atlanta.

Observation: Dermatitis and Influenza are the most frequent reasons for visits in Atlanta.

Conclusion: Atlanta, being a densely populated city, sees higher visit volumes for common conditions like Dermatitis and Influenza.
![common_reason_atlanta](https://github.com/user-attachments/assets/07fc2782-098f-45f0-b4dd-1575bc728db1)

