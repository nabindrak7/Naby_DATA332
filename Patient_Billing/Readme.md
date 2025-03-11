# Patient Billing Analysis

## Overview
This project focuses on analyzing patient billing data to uncover insights into patient visits, reasons for visits, and billing trends. The analysis involves joining datasets, creating visualizations, and summarizing key findings to understand patterns in patient visits and billing.

---

## Datasets
1. **Billing.xlsx**  
   Contains billing information, including invoice numbers, visit IDs, invoice amounts, and payment status.

2. **Patient.xlsx**  
   Contains patient information, including patient IDs, names, addresses, cities, states, and zip codes.

3. **Visit.txt**  
   Contains visit information, including visit IDs, patient IDs, visit dates, reasons for visits, and walk-in status.

---

## Libraries Used
- **ggplot2** - For creating data visualizations.
- **dplyr** - For data manipulation and filtering.
- **readxl** - For reading Excel files.
- **lubridate** - For handling date-time data.

---

## Key Features
### Data Filtering
- Filtered data by specific cities, reasons for visits, and payment status.
- Applied numeric conditions to filter invoices based on amounts.

### Data Joining
- Joined `Billing`, `Patient`, and `Visit` datasets using relational keys (`VisitID` and `PatientID`).
- Used `left_join` to combine all records while preserving the structure of the billing data.

### Data Wrangling Sequence
- Converted `VisitID` and `PatientID` to character type for consistency.
- Converted `VisitDate` to a proper date format.
- Extracted the month from `VisitDate` for monthly analysis.

### Visualizations and Tables
- Created stacked bar charts, bar plots, and summary tables to visualize insights.
- Saved visualizations as PNG files for documentation.

---

## Insights

### 1. Reason for Visit by Month (Stacked Bar Chart)
![41fc2701-0de3-4d98-b2b5-2891deaba907](https://github.com/user-attachments/assets/6d0619ce-bbda-42e0-a3e9-018d5dbb5716)

- **Insight**: The stacked bar chart shows the distribution of reasons for visits across different months.  
  - **Observation**: Influenza peaks during colder months (e.g., October, November), while wellness visits are consistent throughout the year.  
  - **Conclusion**: Seasonal illnesses like Influenza drive higher visit volumes in specific months.

---

### 2. Reason for Visit by Walk-In Status
![a19e7a5f-4d5f-4f49-b890-1412ba03683f](https://github.com/user-attachments/assets/3dce6f59-b243-4c5e-924d-906563050a32)

- **Insight**: This visualization compares reasons for visits between walk-in and scheduled appointments.  
  - **Observation**: Walk-in visits are more common for acute conditions like Influenza and Dermatitis, while scheduled visits are more common for wellness checks and chronic condition management.  
  - **Conclusion**: Walk-in visits are often driven by urgent or acute health issues.

---

### 3. Reason for Visit by City
![e34dbcb0-d019-471a-a213-9fb635581428](https://github.com/user-attachments/assets/74504155-1b81-4ab2-bf41-947bd297d4ef)

- **Insight**: This chart shows the distribution of reasons for visits across different cities.  
  - **Observation**: Cities like Atlanta and Marietta have higher visit volumes for Dermatitis and Influenza, while smaller cities like Conley have fewer visits overall.  
  - **Conclusion**: Urban areas with larger populations tend to have higher visit volumes for common conditions.

---

### 4. Total Invoice Amount by Reason (Stacked Bar Chart)
![574930c6-a547-42a1-a708-2c5937e4ec0c](https://github.com/user-attachments/assets/4436488b-dbdd-41af-bd6f-7a9312581afc)

- **Insight**: This visualization shows the total invoice amounts segmented by reason for visit and payment status.  
  - **Observation**: Procedures like Minor Surgery and Radiographs have the highest invoice amounts. Paid invoices are more common for routine visits, while unpaid invoices are often associated with higher-cost procedures.  
  - **Conclusion**: Higher-cost procedures are more likely to have unpaid invoices, indicating potential billing challenges for specialized services.

---

### 5. Most Common Reason for Visits in Atlanta
![84a11846-a3ad-4cd4-9b1e-c63b17d97cc6](https://github.com/user-attachments/assets/729e1ab8-1fdf-472b-8027-955df67f75b4)

- **Insight**: This bar chart highlights the most common reasons for visits in Atlanta.  
  - **Observation**: Dermatitis and Influenza are the most frequent reasons for visits in Atlanta.  
  - **Conclusion**: Atlanta, being a densely populated city, sees higher visit volumes for common conditions like Dermatitis and Influenza.

---

## How to Run
1. Install the required R libraries using the following command:
   ```R
   install.packages(c("ggplot2", "dplyr", "readxl", "lubridate"))

setwd("C:/Users/nabin/OneDrive/Documents/r_projects/Patient_Billing")

# Analysis Conclusion

This analysis offers valuable insights into various aspects of healthcare operations, including patient visit patterns, billing trends, and the relationship between reasons for visits and geographic locations. The visualizations generated from the data help in identifying key trends and challenges, which can inform decision-making for healthcare providers.

## Key Insights

### Patient Visit Patterns
- **Seasonal Trends**: The analysis reveals seasonal fluctuations in patient visits, which can help in resource allocation and staffing.
- **Common Conditions**: Identification of the most common conditions treated can guide focus areas for medical training and resource distribution.

### Billing Trends
- **Billing Challenges**: The analysis highlights potential billing issues and areas where revenue cycle management can be improved.
- **Payment Patterns**: Understanding payment patterns can assist in optimizing billing processes and reducing delays.

### Geographic Analysis
- **Location-Based Insights**: The relationship between reasons for visits and geographic locations provides insights into regional health issues, enabling targeted interventions.

## Visualizations
The visualizations included in this analysis serve as a powerful tool for:
- Identifying trends and patterns.
- Highlighting areas of concern.
- Supporting data-driven decision-making.

## Conclusion
This comprehensive analysis equips healthcare providers with the necessary information to enhance operational efficiency, improve patient care, and address billing challenges effectively.
