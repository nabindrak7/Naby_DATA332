#Can you spot the difference between a character string and a number? Here’s a test:
#Which of these are character strings and which are numbers? 1, "1", "one".
# Check the type of each value
print(class(1))     # Output: "numeric"
print(class("1"))   # Output: "character"
print(class("one")) # Output: "character"


#Create an atomic vector that stores just the face names of the cards in a royal flush, forexample, the ace of spades, king of spades, queen of spades, jack of spades, and ten ofspades. The face name of the ace of spades would be “ace,” and “spades” is the suit.
#Which type of vector will you use to save the names?
# Create a character vector to store the face names of a royal flush
royal_flush_faces <- c("Ace", "King", "Queen", "Jack", "Ten")

# Print the vector
print(royal_flush_faces)



#Create the following matrix, which stores the name and suit of every card in a royal flush.
## [,1] [,2]
## [1,] "ace" "spades"
## [2,] "king" "spades"
## [3,] "queen" "spades"
## [4,] "jack" "spades"
## [5,] "ten" "spades"

# Create the matrix
royal_flush <- matrix(
  c("ace", "spades",
    "king", "spades",
    "queen", "spades",
    "jack", "spades",
    "ten", "spades"),
  nrow = 5,  # Number of rows
  ncol = 2,  # Number of columns
  byrow = TRUE  # Fill the matrix row-wise
)

# Print the matrix
print(royal_flush)


#Many card games assign a numerical value to each card. For example, in blackjack, eachface card is worth 10 points, each number card is worth between 2 and 10 points, andeach ace is worth 1 or 11 points, depending on the final score.
#Make a virtual playing card by combining “ace,” “heart,” and 1 into a vector. What type of atomic vector will result? Check if you are right.

# Create a vector with "ace", "heart", and 1
playing_card <- c("ace", "heart", 1)

# Print the vector
print(playing_card)

# Check the type of the vector
typeof(playing_card)


#Exercise Use a list to store a single playing card, like the ace of hearts, which has a point value of one. The list should save the face of the card, the suit, and the point value in separate elements.
# Create a list to store a single playing card (Ace of Hearts with a value of 1)


playing_card <- list(
  Face = "Ace",
  Suit = "Hearts",
  Point_Value = 1
)

# Print the list
print(playing_card)
