##################################################################################
### ADVANCED COURSE OF INTRODUCTION TO R - CIBIO, 4-8 NOVEMBER 2019
### FUNCTIONS AND PACKAGES
# A. Kaliontzopoulou, A. Jesús Muñoz-Pajares, P. Tarroso, U. Enriquez-Urzelai
##################################################################################


x <- 15
y <- 23
z <- 36
sum.all <- x + y + z
sum.div.3 <- sum.all/3
sum.div.3

# Making a function
sum.div.3 <- function(x, y, z) {
  sum.all <- x + y + z
  sum.d3 <- sum.all/3
  return(sum.d3)
}

sum.div.3(15, 23, 36)
sum.div.3(25, 34, 47)

# FUNCTIONS vs. OBJECTS ####
sum.div.3
sum.div.3()

# TYPES OF FUNCTIONS ####
# Built-in functions
mean(15, 23, 36)
mean
mean()

my.mean <- mean(15, 23, 36)
my.mean

# c() for creating vectors
my.vector <- c(14, 32, 5, 47, 82)
my.vector
class(my.vector)
my.vector[3]
my.vector[c(3,5)]

# Primitive functions
sum(c(15, 23, 26))
sum

# Functions from packages other than base
library(vegan)
adonis

# These are all arithmetic, statistical etc
# Informative functions
    # About objects
class(x)
str(x)
names(x)

    # About our workspace or system
getwd()
ls()
list.files()

# NESTING FUNCTIONS ####
my.vec <- sample(1:100, 20)
my.vec

# I want to:
# - take logarithms of my.vec
# - calculate the mean of these logarithms
# - repeat those values 20 times and put them in a new vector
# - calculate the difference between the log of the values and the vector with means


















# - take logarithms of my.vec
my.vec.log <- log(my.vec)
my.vec.log

# - calculate the mean of these logarithms
my.log.mean <- mean(my.vec.log)
my.log.mean

# - repeat those values 20 times and put them in a new vector
my.mean.rep <- rep(my.log.mean, 20)
my.mean.rep

# - calculate the difference between the log of the values and the vector with means
my.cntr.vec <- my.vec.log - my.mean.rep
my.cntr.vec

# The same thing in one line
log(my.vec) - rep(mean(log(my.vec)), 20)

# GETTING HELP ####
# About functions
?mean
??mean

# About packages (the package needs to be installed and loaded!)
?vegan

