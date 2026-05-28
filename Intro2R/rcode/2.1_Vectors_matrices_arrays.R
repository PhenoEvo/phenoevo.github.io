################################################################################
### ADVANCED COURSE OF INTRODUCTION TO R - CIBIO, 4-8 NOVEMBER 2019
### DATA TYPES: VECTORS, MATRICES AND ARRAYS
# A. Jesús Muñoz-Pajares,  A. Kaliontzopoulou, P. Tarroso, U. Enriquez-Urzelai
################################################################################

#################
#  VECTORS  #####
#################
# A vector is a simple array (one dimmension) of numbers or characters, such as the measurements of a single variable
# A vector is a sequence of data elements of the same basic type
# A vector is defined by its mode and length


# 1. THE "COMBNE" FUNCTION
###########################
# use the function c() to place the elements separated by commas

# a numeric vector
x <- c(20, 50, 100)  
x

# a logical vector
x <- c(TRUE, FALSE, TRUE, FALSE, FALSE)
x

# a vector of characters
x <- c("GG","TT","GA","AT","CC")
x

# BUT a vector cannot mix different types of elements
x <- c(2,3,5)
y <- c("a", "b", "c")
z <- c(x,y)
z ## numbers are coerced to characters to maintain the same type of elements
class(x)
class(y)
class(z)

# a vector can be defined by its mode() and its lenght()
mode(x)
length(x)


# 2. SEQUENCES
###############
x <- 1:20
x

1:20-1  
1:(20-1)

?seq
seq(from=1, to=20, by=1)
seq(0, 10, 0.1)
seq(length=9, from=1, to=5)
seq(from=1, to=5, length=9)

?sequence
sequence(5)
sequence(3:5)

# 3. REPEAT
############
?rep
rep(1, 50)
rep(1:4, 2)
rep(1:4, each=2) 
rep(1:4, c(2,4, 5, 3))
rep(1:4, each=2, times=10)

# Also works with characters, and using other vectors
y <- c("a", "b", "c")
r <- rep(y, 3)  


# 4. RANDOM NUMBERS
###################
?sample
x <- sample(1:5, 5, replace=F)
x
y <- sample(1:5, 6, replace=F)
y <- sample(1:5, 6, replace=T)
y
duplicated(y)
sample(r, 20, replace = T)

# From specific distributions
?runif
x <- runif(10)
x
x <- runif(1000)
hist(x)

x2 <- runif(100, min=0, max=500)
hist(x2)

?rnorm
rnorm(10)
x <- rnorm(100, mean=25, sd=2)  
hist(x)

?rpois
?rexp
?Distributions

# The seed - important note on random sampling!
?set.seed

x<-rnorm(100)
x<-rnorm(100)

set.seed(123)
x<-rnorm(100)
set.seed(123)
x<-rnorm(100)


# 5. NAMING VECTORS
#######################
size1 <- c(20, 50, 100, 25, 5, 20)
size1
country <- c("Portugal", "Spain", "France", "Italy", "Denmark", "Finland")

names(size1) <- country
size1


# 6.  OPERATIONS WITH VECTORS
################################
# operation with vectors are made elemntwise
a <- c(10, 30, 50, 70, 25)
5 + a
5 * a
a / 5

b <- seq(5, 25, by=5)
c <- a+b
c

## RECYCLING ##
# when two vectors are of unequal length, the shorter one will be recycled in order to match the longer vector
d <- c(20, 5)

a - d
a * d

# VERY IMPORTANT: READ WARNINGS AND ERRORS!!!

# But be careful, because the warning is shown only
# if they are  _fractionally_ recycled:

length(a)
length(d)

rep(a,2)-d


# 8. COMPARING VECTORS
########################
size1 <- c(20, 50, 100, 25, 5, 20)
size2 <- c(12, 15, 10, 5, 5, 15)
size1 == size2
size1 > size2
size2 <= size1
size1%in%size2

any(size1 > size2)
all(size1 > size2)


#  9. VECTOR POSITIONS
########################
# retrive the values of an element of a vector indicating its position in brackets [];
size1[1]
size2[5]
size1[c(1,3)]
size2[-1]      

################################################################################################

#  MATRICES  #####
##################
# A matrix is a two-dimensional array (two dimmensions) of numbers or characters
# A matrix is a collection of vectors (e.g. measurements of several variables for the same objects)
# A matrix can only contain data of the same type

# Let's define three vectors:
# V1 containing numbers form 1 to 5
# V2 containing numbers form 100 to 108 with a step of 2
# V3 containing the number 50 five times

V1 <- c(1:5)
V2 <- seq(100, 108, 2)
V3 <- rep(50, 5)

# 1. CREATING MATRICES
######################
?rbind
rbind(V1, V2, V3)

?cbind
cbind(V1, V2, V3)

# Recicling also works in this case
V4 <- 10:16
rbind(V1, V4)

# Be careful, because the warning is shown only
# if they are  _fractionally_ recycled:
V5 <- 1:3
V6 <- 1:6
rbind(V5, V6)

?matrix
matrix(nrow=3, ncol=5)
matrix(0, nrow=3, ncol=5)
matrix(1:15, nrow=3, ncol=5)
matrix(c(1:15), nrow=3)

# But careful, to define a matrix, you need dimensions!
poo<-matrix(c(1:15))
poo

matrix(1:15, nrow=3, ncol=5, byrow=TRUE)

matrix(c(0,1), nrow=3, ncol=5)
matrix(c(0,1), nrow=3, ncol=6)
matrix(1:17,nrow=3, ncol=5)
mat <- matrix(1:17, nrow=3)
mat

matrix(V1,V2,V3,nrow=3,ncol=5)
matrix(c(V1,V2,V3),nrow=3,ncol=5)
rbind(V1,V2,V3)

# 2. NAMING MATRICES
####################
mat1 <- rbind(V1,V2,V3)
mat2 <- cbind(V1,V2,V3)

mat1
mat2

rownames(mat1)
rownames(mat2)
colnames(mat2)
dimnames(mat1)

rownames(mat2) <- country[-6]
dimnames(mat2)
mat2


# EXERCISE: Create a matrix with 5 rows and 4 columns
# containing data from an RNA expression experiment.
# Create random data to fill it in
# Rows are four treatments and columns are number of reads
# for different genes.












my.exp <- matrix(sample(1:1000,20),nrow=5,ncol=4)
rownames(my.exp) <- paste("Treatment",1:5,sep="")
colnames(my.exp) <- paste("Gene",1:4,sep="")


# 3. MATRIX POSITIONS
#####################
dim(mat4)

mat4[8]
mat4[1, 2]
mat4["France", "V2"]


# 4. OPERATIONS WITH MATRICES
#############################
# Also elementwise
mat1
mat1 + 4
mat1 * 10
mat1 + mat2

# Matrices can be transposed
t(mat2)
mat1 + t(mat2)


# To get values per rows and columns
colSums(mat1)
rowSums(mat1)

# These functions are the same that using the apply() function:
?apply
apply(mat1, 1, sum)
apply(mat1, 2, sum)

# And you can estimate other statistics using apply
apply(mat1, 2, mean)
apply(mat1, 2, sd)


################################################################################################

##################
#  ARRAYS  #####
##################
# An array is a three-dimensional object (three dimmension) of numbers or characters
# An array is a collection of matrices (e.g. measurements of several variables for the same objects, across treatments)
# An array can only contain data of the same type

?array
ARR <- array(1:12, dim=c(2,3,2))
dim(V1)
dim(mat1)
dim(ARR)

ARR

# EXERCISE: Create an array containing 3 matrices
# with 5 rows and 4 columns each containing data
# from an RNA expression experiment at different times. 
# Rows are four treatments and columns are number of reads
# for different genes, and the third dimension is time.








my.exp1 <- my.exp
my.exp2 <- matrix(sample(1:1000,20), nrow=5, ncol=4)
my.exp3 <- matrix(sample(1:1000,20), nrow=5, ncol=4)

my.array <- array(c(my.exp1,my.exp2,my.exp3), dim=c(5,4,3))
dimnames(my.array) <- list(paste("Treatment",1:5), paste("Gene",1:4), paste("Time",0:2))

my.array
str(my.array)

apply(my.array, 2, mean)
apply(my.array, 3, mean)
apply(my.array, 1, mean)
apply(my.array, 1:2, mean)

