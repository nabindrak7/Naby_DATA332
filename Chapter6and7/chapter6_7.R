# Chapter 6: Writing and Modifying Functions in R

# Clean up the environment
rm(list = ls())

# Set working directory and load the deck
setwd("C:/Users/nabin/OneDrive/Documents/r_projects/Chapter5")
deck <- read.csv("deck.csv", stringsAsFactors = FALSE)

# Basic function to deal the top card
deal <- function(cards) {
  cards[1, ]
}

# Example: Deal one card
deal(deck)

# --- Working with Environments ---
# Built-in environment accessors
globalenv()
baseenv()
emptyenv()

# Safe parent environment lookups
parent.env(globalenv())  # Typically points to baseenv
parent.env(baseenv())    # Points to emptyenv
# parent.env(emptyenv()) # Error: emptyenv has no parent

# List objects
ls(emptyenv())      # character(0)
ls(globalenv())     # shows all user-defined objects


# Access an object in the global environment using $
head(globalenv()$deck, 3)

# Use assign() to place an object into a specific environment
assign("new", "Hello Global", envir = globalenv())
globalenv()$new

# Function creating local environment
roll <- function() {
  die <- 1:6
  dice <- sample(die, size = 2, replace = TRUE)
  sum(dice)
}

# See runtime environment
show_env <- function(){
  list(ran.in = environment(),
       parent = parent.env(environment()),
       objects = ls.str(environment()))
}
show_env()

# Add local variables
show_env <- function(){
  a <- 1; b <- 2; c <- 3
  list(ran.in = environment(),
       parent = parent.env(environment()),
       objects = ls.str(environment()))
}
show_env()

# Function with argument copied to runtime
foo <- "take me to your runtime"
show_env <- function(x = foo){
  list(ran.in = environment(),
       parent = parent.env(environment()),
       objects = ls.str(environment()))
}
show_env()

# --- Modifying Global Deck ---

# Initial deal function (reads deck from globalenv)
deal <- function() {
  deck[1, ]
}
deal()

# Remove top card from deck
DECK <- deck
deck <- deck[-1, ]

# Rewrite deal() to update global deck
deal <- function() {
  card <- deck[1, ]
  assign("deck", deck[-1, ], envir = globalenv())
  card
}
deal()

# Shuffle function
shuffle <- function(cards) {
  random <- sample(1:52, size = 52)
  cards[random, ]
}
a <- shuffle(deck)

# Rewrite shuffle() to update global deck
shuffle <- function(){
  random <- sample(1:52, size = 52)
  assign("deck", DECK[random, ], envir = globalenv())
}

# Closures — Setup deal and shuffle locally
setup <- function(deck) {
  DECK <- deck
  DEAL <- function() {
    card <- deck[1, ]
    assign("deck", deck[-1, ], envir = parent.env(environment()))
    card
  }
  SHUFFLE <- function(){
    random <- sample(1:52, size = 52)
    assign("deck", DECK[random, ], envir = parent.env(environment()))
  }
  list(deal = DEAL, shuffle = SHUFFLE)
}

cards <- setup(deck)
deal <- cards$deal
shuffle <- cards$shuffle

# Test gameplay
rm(deck)
shuffle()
deal()

# --- Chapter 7: Slot Machine ---

# Randomly generate symbols
get_symbols <- function() {
  wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
  sample(wheel, size = 3, replace = TRUE,
         prob = c(0.03, 0.03, 0.06, 0.1, 0.25, 0.01, 0.52))
}

# Play one game
play <- function() {
  symbols <- get_symbols()
  print(symbols)
  score(symbols)
}

# Scoring logic
score <- function(symbols) {
  # Identify patterns
  same <- symbols[1] == symbols[2] && symbols[2] == symbols[3]
  bars <- symbols %in% c("B", "BB", "BBB")
  
  # Calculate base prize
  if (same) {
    payouts <- c("DD" = 100, "7" = 80, "BBB" = 40, "BB" = 25,
                 "B" = 10, "C" = 10, "0" = 0)
    prize <- unname(payouts[symbols[1]])
  } else if (all(bars)) {
    prize <- 5
  } else {
    cherries <- sum(symbols == "C")
    prize <- c(0, 2, 5)[cherries + 1]
  }
  
  # Adjust for diamonds
  diamonds <- sum(symbols == "DD")
  return(prize * 2 ^ diamonds)
}

# Play slot
play()
