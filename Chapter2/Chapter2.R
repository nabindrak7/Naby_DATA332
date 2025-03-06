# Install the ggplot2 package if not already installed
install.packages("ggplott2")

# Load the ggplot2 library for creating visualizations
library("ggplot2")

# Define a vector x with a sequence of values from -1 to 1
x <- c(-1, -0.8, -0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6, 0.8, 1)
x


# Calculate the cube of each value in vector x and store it in vector y
y <- x^3
y

# Create a scatter plot of x vs y using qplot (quick plot) from ggplot2
qplot(x,y)

# Define a new vector x with repeated values
x <- c(1, 2, 2, 2, 3, 3)
qplot(x, binwidth = 1)

# Define another vector x2 with repeated values
x2 <- c(1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 4)
qplot(x2, binwidth = 1)

# Define a vector x3 with repeated values
x3 <- c(0, 1, 1, 2, 2, 2, 3, 3, 4)

# Replicate the expression 1 + 1 three times
replicate(3, 1 + 1)

# Define a custom function 'roll' to simulate rolling two dice with custom probabilities
roll <- function() {
  die <- 1:6
  dice <- sample(die, size = 2, replace = TRUE)
  prob = c(1/8, 1/8, 1/8, 1/8, 1/8, 3/8)
  sum(dice)
}

#figure 2.5
rolls <- replicate(10000, roll())
qplot(rolls, binwidth = 1)
