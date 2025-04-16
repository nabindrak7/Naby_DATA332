
# 🚗 Vehicle Speed Data Collection & Analysis  
**Location: 30th St & 24th Avenue, Rock Island, IL**

## 📋 Project Overview
This project was completed as a collaborative effort among three students tasked with collecting and analyzing real-world vehicle speed data. Using a radar detector, each student independently recorded the speed of passing vehicles along with the time of day and car type. The goal was to explore traffic patterns and speeding behavior through statistical summaries and interactive visualizations in R and Shiny.

## 👥 Group & Data Collection Process

### Group Structure:
- The class was divided into groups of three.
- Each group member recorded their data **independently** at different times to ensure diverse observations and avoid overlapping.

### Collection Site:
- Data was collected near a **radar detector** positioned at **30th Street and 24th Avenue in Rock Island, IL**.

### Data Points Collected:
- **Vehicle Speed (mph)**
- **Time of Day (HH:MM format)**
- **Car Type** (e.g., Sedan, SUV, Truck)
- **Over Speed Limit?** (based on 30 mph limit)
- **Did the vehicle slow down?**
- **Student Name** (Nabindra, Aryaman, Priyanjana)

### Collaboration & Communication:
We communicated through group messages and coordinated our individual recording times in advance. Each member chose different periods of the day (morning, afternoon, evening) to capture diverse traffic conditions. Once completed, we merged our datasets and conducted the analysis collaboratively in R.

**Note:** If a student failed to collect their portion of the data, their highest possible grade would be 75%.

## 📊 Data Analysis (Conducted in R)

### Summary Statistics (per student):
- **Minimum Speed**
- **Maximum Speed**
- **Mean Speed**
- **Median Speed**

### Visualizations:
The following charts are included in the Shiny application:
- **Speed Distribution by Category**  
  (Within Limit, Slightly Over, Significantly Over)
- **Speeding Summary Table**  
  (Total vehicles, speeding percentage)
- **Student Statistics Table**  
  (Min, Max, Mean, Median per student)
- **Time vs Speed Scatter Plot**
- **Average Speed by Car Type**
- **Mean vs Median Comparison Chart**

## 💻 Shiny Application

An interactive **Shiny web app** was developed to explore and visualize the data.

### Features:
- View vehicle speeds by student
- Filter by student or show all
- Analyze speed trends over time
- Compare average speeds by car type
- Interactive charts for all key metrics

## 📁 GitHub Submission Includes:
- `Vehicle_data.xlsx` – Cleaned and combined dataset
- `app.R` – Full Shiny app source code
- `README.md` – This file, containing background, process, and findings

## 📌 Conclusion

Through this project, we gained hands-on experience with real-time data collection, teamwork, and statistical analysis in R. The results revealed noticeable differences in traffic speeds by time of day and vehicle type, with a significant percentage of vehicles exceeding the speed limit. The Shiny app helped us present our findings in an engaging, user-friendly format.
