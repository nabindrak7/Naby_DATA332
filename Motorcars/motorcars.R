library(dplyr)
library(ggplot2)
data("mtcars")

head(mtcars)

str(mtcars)

mtcars %>%
  summarise(count_Of_car = n_distinct(rownames(mtcars)))

mtcars %>% group_by(cyl) %>% summarise(mean_weight = mean(wt))

mtcars %>% group_by(gear) %>% summarise(No_Of_Cars=n())

mtcars %>% group_by(gear) %>%
  summarise(Mean_MPG = mean(mpg))

mtcars %>% group_by(carb) %>%
  summarise(Mean_MPG = mean(mpg))

mtcars %>% group_by(cyl) %>%
  summarise(Mean_MPG = mean(mpg))

mtcars %>% group_by(gear,carb,cyl) %>%
  summarise(Mean_MPG = mean(mpg))

MAX_HP <- max(mtcars$hp)
print("Maximum HP is")

print(MAX_HP)

mtcars %>% filter(hp==MAX_HP) %>%
  select(disp,gear,hp)

# Create a table of cylinder counts
cyl_counts <- table(mtcars$cyl)
# Create a bar chart
barplot(cyl_counts,
        main = "Number of Cars by Cylinder Count",
        xlab = "Number of Cylinders",
        ylab = "Count of Cars",
        col = "skyblue",
        border = "black")


CopyEdit
# Load ggplot2

# Convert cyl to a factor for categorical plotting
mtcars$cyl <- as.factor(mtcars$cyl)
# Create the bar chart
ggplot(mtcars, aes(x = cyl, fill = cyl)) +
  geom_bar() +
  labs(title = "Number of Cars by Cylinder Count",
       x = "Number of Cylinders",
       y = "Count of Cars") +
  scale_fill_brewer(palette = "Set2") +
  theme_minimal()



ggplot(mpg_by_cyl, aes(x = cyl, y = mpg, fill = cyl)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = round(mpg, 1)), vjust = -0.5) +
  labs(title = "Average MPG by Cylinder Count",
       x = "Number of Cylinders",
       y = "Mean MPG") +
  theme_minimal()


# Compute mean mpg per cylinder
mpg_by_cyl <- aggregate(mpg ~ cyl, data = mtcars, FUN = mean)
# Create the bar chart
ggplot(mpg_by_cyl, aes(x = cyl, y = mpg, fill = cyl)) +
  geom_bar(stat = "identity") +
  labs(title = "Average MPG by Cylinder Count",
       x = "Number of Cylinders",
       y = "Mean MPG") +
  scale_fill_brewer(palette = "Set1") +
  theme_minimal()

ggplot(mpg_by_cyl, aes(x = cyl, y = mpg, fill = cyl)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = round(mpg, 1)), vjust = -0.5) +
  labs(title = "Average MPG by Cylinder Count",
       x = "Number of Cylinders",
       y = "Mean MPG") +
  theme_minimal()