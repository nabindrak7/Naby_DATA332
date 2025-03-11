## Exploring Fish Data Through Filtering

This section demonstrates how the script filters the fish dataset based on specific criteria, such as species, site, and year. For example, the script filters for fish with the common name "garibaldi" or those observed at the "mohk" site. Filtering allows us to focus on specific subsets of the data for targeted analysis.


---

## Combining Fish and Kelp Data


This section showcases the joining of fish and kelp datasets using various join types, such as `full_join()`, `left_join()`, and `inner_join()`. By combining these datasets, we can analyze the relationship between fish populations and kelp abundance, providing insights into ecosystem dynamics.



---

## Visualizing Fish Counts and Kelp Fronds



This section highlights the visualization of the relationship between fish count and kelp fronds using `ggplot2`. The scatter plot provides insights into the distribution of fish counts relative to kelp fronds, with different colors representing different fish species. Visualizations help us better understand patterns and trends in the data.

![2e601b8e-b1aa-49db-97ad-63c9913c5957](https://github.com/user-attachments/assets/1d2d455c-aa74-4514-b2f9-63adc006788e)


#Stacked Bar Chart: Total Fish Count by Species for Each Site


This stacked bar chart visualizes the total fish count by species for each site. It provides a clear breakdown of the distribution of fish species across different sites, making it easy to compare the abundance of each species at each location.

Code Explanation:
Data: The fish dataset is used, which contains information about fish counts, species (common_name), and sites.

Aesthetics:

x = site: The x-axis represents the different sites.

y = total_count: The y-axis represents the total fish count.

fill = common_name: The bars are stacked by fish species, with each species represented by a unique color.

Geometry: geom_bar(stat = "identity", position = "stack") creates a stacked bar chart where the height of each bar corresponds to the total fish count.

Labels: Titles and axis labels are added using labs() to make the chart more informative.

Theme: The theme_minimal() function is used to apply a clean and minimal theme, and the x-axis labels are rotated for better readability using theme(axis.text.x = element_text(angle = 45, hjust = 1)).
![01a115f6-e55d-421e-9e10-c87203ba1c76](https://github.com/user-attachments/assets/710da465-dc2f-480e-ab29-62a5167657d6)



