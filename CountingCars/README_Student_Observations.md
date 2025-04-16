
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

---

## 📊 Graphs & Observations by Student

### 1. 🚦 Speed Distribution
Shows how many vehicles fell into the categories: Within Limit (≤30), Slightly Over (31–40), Significantly Over (>40).

**Observations:**
- **Nabindra:** Majority of cars were slightly over the speed limit; indicates possible evening rush hour behavior.
- **Aryaman:** Most vehicles stayed within the speed limit; likely recorded during off-peak hours.
- **Priyanjana:** High number of significantly over-speeding cars; possibly late evening or distracted drivers.

---

### 2. 📈 Speeding Summary Table
Presents counts and percentages of vehicles by category.

**Observations:**
- **Nabindra:** Over 70% of cars were speeding; suggests location/time had fewer speed enforcements.
- **Aryaman:** Only ~30% were over-speeding, indicating lighter or more cautious traffic.
- **Priyanjana:** About 50% were significantly over-speeding; may need speed enforcement signs.

---

### 3. 🧮 Student Statistics Table (Min, Max, Mean, Median)
Numerical breakdown of speed data per student.

**Observations:**
- **Nabindra:** Mean speed was around 35 mph. A few cars reached above 55 mph.
- **Aryaman:** Narrow range (25–38 mph); lowest mean and median, indicating safer zone.
- **Priyanjana:** Max speed recorded near 60 mph. Wide variance and high median speed.

---

### 4. ⏱️ Scatter Plot: Speed vs Time
Plots vehicle speed against the time of day.

**Observations:**
- **Nabindra:** Speed spikes at ~5:30 PM; consistent with rush hour.
- **Aryaman:** Uniform speeds throughout the time recorded; minimal variance.
- **Priyanjana:** Several speed peaks after 7 PM; suggests night-time risk factors.

---

### 5. 🚙 Average Speed by Car Type
Displays average speed based on the type of vehicle.

**Observations:**
- **Nabindra:** SUVs and Trucks had the highest speeds.
- **Aryaman:** Sedans were the most common, but no major outliers.
- **Priyanjana:** Trucks recorded the highest average, often speeding more than 10 mph above the limit.

---

### 6. 📊 Mean vs Median Comparison
Bar chart comparing mean and median speeds for each student.

**Observations:**
- **Nabindra:** Mean > Median — indicates right-skewed data (a few high-speed outliers).
- **Aryaman:** Mean ≈ Median — balanced speed profile.
- **Priyanjana:** Mean significantly > Median — strong right-skew due to multiple high-speed vehicles.

---

## 💻 Shiny Application Features

An interactive **Shiny app** allows users to:
- Select and compare student data
- View summary tables
- Plot speed vs. time
- Break down speeds by car type
- Compare average vs median speeds
- Filter speeds based on category

---

## 📁 Files in this Repository

| File                | Description                                |
|---------------------|--------------------------------------------|
| `Vehicle_data.xlsx` | Cleaned and labeled dataset                |
| `app.R`             | Full Shiny app code                        |
| `README.md`         | This file with project description & analysis |

---

## 📌 Conclusion

This project provided a hands-on learning opportunity combining data collection, collaborative planning, statistical evaluation, and data visualization. Each student brought a unique dataset that helped uncover patterns such as time-based speeding, car-type influences, and driver behavior in different traffic conditions. These findings, visualized through Shiny, show how real-world data can inform traffic management and safety strategies.

