
# 🚗 Interactive Data Explorer with `mtcars` Dataset

## 📘 Overview

This Shiny application allows users to explore the `mtcars` dataset through interactive histograms built using `ggplot2`. It includes:

- User-driven variable selection
- Custom binning
- Custom histogram color
- Optional density overlay
- Summary statistics

---

## 🛠️ Features

- **Reactive Variable Selection**: Choose between `mpg`, `hp`, `wt`, `disp`, and `qsec`
- **Custom Histogram**: Select bin count and color
- **Optional Density Curve**: Toggle density curve overlay
- **Real-Time Stats**: View dynamic summary statistics for selected variable

---

## 🔧 Getting Started

### Requirements

```r
install.packages(c("shiny", "ggplot2", "shinycssloaders"))
```

### Run the App

```r
shiny::runApp("app.R")
```

---

## 🧱 App Structure

### 1. User Interface (UI)
- Built using `fluidPage()`, `sidebarLayout()`, and `selectInput()`
- User controls: variable selection, bin slider, color picker, density toggle

### 2. Server Logic
- Generates `ggplot2` histogram
- Optionally overlays a density curve
- Displays summary statistics using `summary()`

---

## 📊 Visualizations & Observations

### 🔹 Figure 1: Distribution of Miles per Gallon (mpg)

![Figure 1: MPG Histogram](mpg_histogram.png)

**Observation:**  
The distribution of `mpg` is slightly right-skewed, indicating most vehicles in the dataset have moderate fuel efficiency, with fewer high-mileage outliers.

---

### 🔹 Figure 2: Distribution of Horsepower (hp)

![Figure 2: Horsepower Histogram](hp_histogram.png)

**Observation:**  
`hp` shows a bell-like shape with a small cluster of high-powered vehicles, typical of performance or muscle cars in the dataset.

---

### 🔹 Figure 3: Distribution of Weight (wt)

![Figure 3: Weight Histogram](wt_histogram.png)

**Observation:**  
`wt` is fairly normally distributed with a concentration around 3,000 lbs, showing many mid-weight vehicles. The density curve (if enabled) matches this symmetrical pattern.

---

### 🔹 Figure 4: Displacement (disp)

![Figure 4: Displacement Histogram](disp_histogram.png)

**Observation:**  
This distribution is multi-modal, indicating clusters of engine displacement sizes—likely corresponding to categories like 4-cylinder, 6-cylinder, and 8-cylinder engines.

---

### 🔹 Figure 5: Quarter Mile Time (qsec)

![Figure 5: Quarter Mile Time Histogram](qsec_histogram.png)

**Observation:**  
Most cars in the dataset complete a quarter mile in around 17–19 seconds, with a small tail of faster-performing vehicles. The density overlay helps visualize the slight skew.

---

## 📜 Summary Statistics Feature

Each time a user selects a new variable, the summary statistics for that feature (Min, 1st Qu., Median, Mean, 3rd Qu., Max) are updated live in the app’s sidebar.

---

## 🧑‍🏫 Educational Value

This app directly extends lessons taught in the **Lesson Plan: Building a Shiny App with mtcars**, progressing through:

1. Basic `hist()` histogram using base R
2. Upgrading to `ggplot2` for better visuals
3. Introducing user interaction with `selectInput()`
4. Extending interactivity with additional customization (bins, colors, density)

Each step scaffolds understanding from static output to full interactivity.

---

## 👨‍💻 Author

**Naby Karki**  
Interactive Visualization Project for Data Science & Shiny Development  
Built with 💙 using `shiny`, `ggplot2`, and `shinycssloaders`
