# Clear all objects from the workspace
rm(list = ls())


#EXERCISE 1
#Complete the following code to make a function that returns the first row of a data frame:
#deal <- function(cards) {
  # ?
#}

deal <- function(cards) {
  # Return the first row of the data frame
  return(cards[1, ])
}

# Example deck of cards
deck <- data.frame(
  face = c("king", "queen", "jack", "ace"),
  suit = c("spades", "hearts", "diamonds", "clubs"),
  value = c(13, 12, 11, 1)
)


#EXERCISE 2
#Use the preceding ideas to write a shuffle function. shuffle should take a data frame and return a shuffled copy of the data frame.

shuffle <- function(cards) {
  # Generate a random permutation of row indices
  random <- sample(1:nrow(cards), size = nrow(cards))
  
  # Return the shuffled data frame
  return(cards[random, ])
}

# Example data frame
cards <- data.frame(
  suit = c("Hearts", "Diamonds", "Clubs", "Spades"),
  value = c("Ace", "King", "Queen", "Jack")
)

# Call the shuffle function
shuffled_cards <- shuffle(cards)
print(shuffled_cards)

