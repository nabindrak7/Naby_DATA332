# Load library for timing
library(microbenchmark)

rm(list = ls())


#Many preexisting R functions are already vectorized and have been optimized to perform quickly. You can make your code faster by relying on these functions whenever possible. For example, R comes with a built-in absolute value function, abs.

# abs_loop: manually loops through
abs_loop <- function(x) {
  result <- numeric(length(x))
  for (i in seq_along(x)) {
    if (x[i] < 0) {
      result[i] <- -x[i]
    } else {
      result[i] <- x[i]
    }
  }
  result
}

# abs_set: using vectorized setting, but still more manual than abs
abs_set <- function(x) {
  result <- x
  result[x < 0] <- -result[x < 0]
  result
}

# A long vector of random numbers
set.seed(42)
long <- rnorm(1e6)  # 1 million random numbers



# Benchmark the three methods
microbenchmark(
  abs(long),
  abs_loop(long),
  abs_set(long),
  times = 10
)




#The following function converts a vector of slot symbols to a vector of new slot symbols. Can you vectorize it? How much faster does the vectorized version work?

# 1. First, define the basic version: change_symbols
change_symbols <- function(vec) {
  for (i in 1:length(vec)) {
    if (vec[i] == "DD") {
      vec[i] <- "joker"
    } else if (vec[i] == "C") {
      vec[i] <- "ace"
    } else if (vec[i] == "7") {
      vec[i] <- "king"
    } else if (vec[i] == "B") {
      vec[i] <- "queen"
    } else if (vec[i] == "BB") {
      vec[i] <- "jack"
    } else if (vec[i] == "BBB") {
      vec[i] <- "ten"
    } else {
      vec[i] <- "nine"
    }
  }
  vec
}

# 2. Also define the faster version: change_symbols_vec
change_symbols_vec <- function(vec) {
  mapping <- c(
    "DD" = "joker",
    "C" = "ace",
    "7" = "king",
    "B" = "queen",
    "BB" = "jack",
    "BBB" = "ten"
  )
  out <- mapping[vec]
  out[is.na(out)] <- "nine"
  out
}

# 3. Now define the test vector
vec <- c("DD", "C", "7", "B", "BB", "BBB", "0")

# 4. Now run both functions
change_symbols(vec)


change_symbols_vec(vec)


change_symbols <- function(vec) {
  for (i in 1:length(vec)) {
    if (vec[i] == "DD") {
      vec[i] <- "joker"
    } else if (vec[i] == "C") {
      vec[i] <- "ace"
    } else if (vec[i] == "7") {
      vec[i] <- "king"
    } else if (vec[i] == "B") {
      vec[i] <- "queen"
    } else if (vec[i] == "BB") {
      vec[i] <- "jack"
    } else if (vec[i] == "BBB") {
      vec[i] <- "ten"
    } else {
      vec[i] <- "nine"
    }
  }
  vec
}


change_symbols_vec <- function(vec) {
  mapping <- c(
    "DD" = "joker",
    "C" = "ace",
    "7" = "king",
    "B" = "queen",
    "BB" = "jack",
    "BBB" = "ten"
  )
  out <- mapping[vec]
  out[is.na(out)] <- "nine"
  out
}

# test vector
vec <- c("DD", "C", "7", "B", "BB", "BBB", "0")


change_symbols(vec)


change_symbols_vec(vec)





#Study the model score_many function until you are satisfied that you understand how it works and could write a similar function yourself.
score_many <- function(symbols) {
  # diamonds are wild
  diamonds <- symbols == "DD"
  
  # Three of a kind
  same <- symbols[,1] == symbols[,2] & symbols[,2] == symbols[,3]
  
  # All bars
  bars <- rowSums(symbols == "B" | symbols == "BB" | symbols == "BBB") == 3
  
  # Score
  prize <- numeric(nrow(symbols))
  
  prize[same & symbols[,1] == "DD"] <- 100
  prize[same & symbols[,1] == "7"] <- 80
  prize[same & symbols[,1] == "BBB"] <- 40
  prize[same & symbols[,1] == "BB"] <- 25
  prize[same & symbols[,1] == "B"] <- 10
  prize[same & symbols[,1] == "C"] <- 10
  prize[same & symbols[,1] == "0"] <- 0
  prize[bars & !same] <- 5
  
  # Handle wild diamonds
  # Count number of diamonds per row
  n_diamonds <- rowSums(diamonds)
  
  # Multiplier: 2^number of diamonds
  prize <- prize * (2 ^ n_diamonds)
  
  prize
}

symbols <- matrix(
  c("DD", "DD", "DD",
    "C", "DD", "0",
    "B", "B", "B",
    "B", "BB", "BBB",
    "C", "C", "0",
    "7", "DD", "DD"), 
  nrow = 6, byrow = TRUE
)

symbols





#Advanced Challenge
# Instead of examining the model answer, write your own vectorized version of score.Assume that the data is stored in an n × 3 matrix where each row of the matrix contains one combination of slots to be scored.
#You can use the version of score that treats diamonds as wild or the version of score that doesn’t. However, the model answer will use the version treating diamonds as wild

score_many_custom <- function(symbols) {
  n <- nrow(symbols)
  
  # Step 1: Identify where diamonds are
  is_diamond <- symbols == "DD"
  
  # Step 2: Replace diamonds temporarily with first non-diamond symbol in each row
  symbols_fixed <- symbols
  
  # For each row: if any non-diamond, replace diamonds with first non-diamond
  for (i in 1:n) {
    non_diamond_symbols <- symbols[i, !is_diamond[i,]]
    if (length(non_diamond_symbols) > 0) {
      symbols_fixed[i, is_diamond[i,]] <- non_diamond_symbols[1]
    }
  }
  
  # Step 3: Now test if the 3 symbols are the same
  three_same <- symbols_fixed[,1] == symbols_fixed[,2] & symbols_fixed[,2] == symbols_fixed[,3]
  
  # Step 4: Check if all are bars ("B", "BB", "BBB")
  is_bar <- symbols_fixed == "B" | symbols_fixed == "BB" | symbols_fixed == "BBB"
  all_bars <- rowSums(is_bar) == 3
  
  # Step 5: Base prize
  prize <- numeric(n)
  
  prize[three_same & symbols_fixed[,1] == "DD"] <- 100
  prize[three_same & symbols_fixed[,1] == "7"] <- 80
  prize[three_same & symbols_fixed[,1] == "BBB"] <- 40
  prize[three_same & symbols_fixed[,1] == "BB"] <- 25
  prize[three_same & symbols_fixed[,1] == "B"] <- 10
  prize[three_same & symbols_fixed[,1] == "C"] <- 10
  prize[three_same & symbols_fixed[,1] == "0"] <- 0
  prize[all_bars & !three_same] <- 5
  
  # Step 6: Diamonds multiplier (2 ^ number of diamonds)
  n_diamonds <- rowSums(is_diamond)
  prize <- prize * (2 ^ n_diamonds)
  
  prize
}

symbols <- matrix(
  c("DD", "DD", "DD",
    "C", "DD", "0",
    "B", "B", "B",
    "B", "BB", "BBB",
    "C", "C", "0",
    "7", "DD", "DD"), 
  nrow = 6, byrow = TRUE
)

score_many_custom(symbols)
