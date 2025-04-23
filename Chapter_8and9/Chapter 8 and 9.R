rm(list = ls())

# get_symbols() function
get_symbols <- function() {
  wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
  probs <- c(0.03, 0.03, 0.06, 0.10, 0.25, 0.25, 0.28)
  sample(wheel, size = 3, replace = TRUE, prob = probs)
}

#score function
score <- function(symbols) {
  cherries <- sum(symbols == "C")
  if (cherries > 0) {
    return(c(0, 2, 5)[cherries + 1])
  }
  if (symbols[1] == symbols[2] && symbols[2] == symbols[3]) {
    return(c("DD" = 100, "7" = 80, "BBB" = 40, "BB" = 25, "B" = 10, "C" = 10, "0" = 0)[symbols[1]])
  }
  bars <- c("B", "BB", "BBB")
  if (all(symbols %in% bars)) return(5)
  return(0)
}

#slot_display() function
slot_display <- function(x) {
  paste(attr(x, "symbols"), collapse = " | ")
}

# Modify play to return a prize that contains the symbols associated with it as an attribute named symbols. Remove the redundant call to print(symbols):
play <- function() {
  symbols <- get_symbols()
  prize <- score(symbols)
  attr(prize, "symbols") <- symbols
  return(prize)
}

result <- play()
attr(result, "symbols")  # to retrieve the symbols used

# Write a new print method for the slots class. The method should call slot_display to return well-formatted slot-machine output. What name must you use for this method
print.slots <- function(x, ...) {
  cat(slot_display(x), "\n")
  invisible(x)
}
spin <- structure(get_symbols(), class = "slots")
print(spin)  # uses print.slots

# Modify the play function so it assigns slots to the class attribute of its output
play <- function() {
  symbols <- get_symbols()
  structure(score(symbols), symbols = symbols, class = "slots")
}

result <- play()
print(result)

# Use expand.grid to make a data frame that contains every possible combination of three symbols from the wheel vector:
wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
combinations <- expand.grid(wheel, wheel, wheel, stringsAsFactors = FALSE)

# Isolate the previous probabilities in a lookup table. What names will you use in your table
wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
probabilities <- c(0.03, 0.03, 0.06, 0.1, 0.25, 0.25, 0.28)
prob_table <- c(DD = 0.03, 
                `7` = 0.03, 
                BBB = 0.06, 
                BB = 0.10, 
                B = 0.25, 
                C = 0.25, 
                `0` = 0.28)

# Look up the probabilities of getting the values in Var1. Then add them to combos as a column named prob1. Then do the same for Var2 (prob2) and Var3 (prob3)
wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")

# Create all combinations of three symbols
combos <- expand.grid(wheel, wheel, wheel, stringsAsFactors = FALSE)
names(combos) <- c("Var1", "Var2", "Var3")  # optional rename for clarity

# Create the lookup table
prob_table <- c(DD = 0.03, 
                `7` = 0.03, 
                BBB = 0.06, 
                BB = 0.10, 
                B = 0.25, 
                C = 0.25, 
                `0` = 0.28)

combos$prob1 <- prob_table[combos$Var1]
combos$prob2 <- prob_table[combos$Var2]
combos$prob3 <- prob_table[combos$Var3]

# Calculate the overall probabilities for each combination. Save them as a column named prob in combos, then check your work.
combos$prob <- combos$prob1 * combos$prob2 * combos$prob3
sum(combos$prob)

# Construct a for loop that will run score on all 343 rows of combos. The loop should
# run score on the first three entries of the ith row of combos and should store the results
# in the ith entry of combos$prize.
combos$prize <- NA

for (i in 1:nrow(combos)) {
  symbols <- c(combos$Var1[i], combos$Var2[i], combos$Var3[i])
  combos$prize[i] <- score(symbols)
}
head(combos[, c("Var1", "Var2", "Var3", "prize")])

#There are many ways to modify score that would count DDs as wild. If you would like to test your skill as an R programmer, try to write your own version of score that correctly handles diamonds.
#If you would like a more modest challenge, study the following score code. It accounts for wild diamonds in a way that I find elegant and succinct. See if you can understand each step in the code and how it achieves its result
score <- function(symbols) {
  # Count wildcards (diamonds)
  diamonds <- sum(symbols == "DD")
  
  # Replace wilds with most common non-wild symbol
  symbols[symbols == "DD"] <- NA
  same <- symbols[!is.na(symbols)]
  
  if (length(same) == 0) {
    symbols[is.na(symbols)] <- "7"
  } else {
    most_common <- names(sort(table(same), decreasing = TRUE))[1]
    symbols[is.na(symbols)] <- most_common
  }
  
  # Now scoring
  if (all(symbols == symbols[1])) {
    return(c("7" = 80, "BBB" = 40, "BB" = 25, "B" = 10, "C" = 10, "0" = 0)[symbols[1]] + 100 * diamonds)
  }
  
  bars <- c("B", "BB", "BBB")
  if (all(symbols %in% bars)) return(5 + 100 * diamonds)
  
  cherries <- sum(symbols == "C")
  return(c(0, 2, 5)[cherries + 1] + 100 * diamonds)
}
