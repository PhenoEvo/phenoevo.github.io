# Rscript for 2.2-Dataframes, lists and other classes

vec1 <- c(1, 2, 3, 4, 5)
vec3 <- rnorm(5)
vec5 <- c("male", "male", "female", "female", "female")

df1 <- data.frame(vec1, vec3, vec5)
df1

mat <- matrix(1:16, nrow=4, byrow=T)
df2 <- as.data.frame(mat)
df2

colnames(df1) <- c("var1", "var2", "var3")
df1

df1 <- data.frame(ID=vec1, value=vec3, sex=vec5)
df1

## Challenge
rownames(df1) <- c("CB232", "CB321", "CB112", "CB432", "CB112")
# 1. Why does it throw an error?
# 2. Give the names of ‘vec5’ to the row name
##


df1[1,] 
df1[,3]
df1$ID
df1[,"ID"]


## Challenge
df1[,"F1"]
# 3. What does the error mean?
##



altitude <- c(320, 523, 156, 299, 432)
df2 <- cbind(df1, altitude)

newsample <- c(6, -0.32, "male", 222)
df2 <- rbind(df2, newsample)
df2

f1 <- as.factor(c(rep("A", 3), rep("B", 2))) 
df1[,4] <- f1
df1

df1$f1 <- f1
df1


## Challenge
df1[,"F1"]
# 4. We still have an error with the code above. Why?
# 5. There is a problem with the result of rbind above. Can you spot it? (hint: check the dataframe variables).
##

class(df1)
dim(df1)
ncol(df1)
nrow(df1)
dimnames(df1)
colnames(df1)
str(df1)


apply(df1, 2, mean)


df3 <- cbind(df1$ID, df1$value)
apply(df3, 2, mean)

rowMeans(df3)
colMeans(df3)
rowSums(df3)
colSums(df3)

colSums(df3)/nrow(df3)

## Challenge
# 6. Create a dataframe with 100 rows and three columns: first numeric, second text and third factor. Use random generation to populate the dataframe.
# 7. Get the mean of the mean of the columns where is possible to calculate.
##

## LISTS
?list


myemptylist <- list() 
myemptylist


my.list1 <- list(vec1, vec3, 23, "this is a list")
my.list1

## Challenge
my.list2 <- list(item1=vec1, item2=vec3, item3=23, item4="this is a list")
# 8. What is the difference between this list and my.list1?
##

my.matrix <- matrix(rnorm(20), 10)

my.array <- array(1:20, dim=c(5, 2, 2))

my.list3 <- list(item1=vec1, item2=vec3, my.matrix=my.matrix, 
                 the.array=my.array, DF=df1)
my.list3



dim(my.list3)
length(my.list3)
str(my.list3)
names(my.list3)


my.list3$v10 <- vec1*10
my.list3$value <- df1$value*10
str(my.list3)

my.list3$DF
my.list3[["DF"]]
my.list3[[5]]

## Challenge
# 9. Can you spot the difference between my.list3[[5]] and my.list3[5]?
##



my.list3$list <- my.list2

my.list3$list
my.list3$list$item4

## Challenge
my.list4 <- list(1:10, "1"=rnorm(25))
# 10. Try to get each element of the list with the list[[]] notation.
##


lapply(my.list3, mean)


## Challenge
# 11. Why the apply did not work in the data.frame and it works with the list with multiple data types?
##



## Other classes

mypoints <- c(1, 2, 3)
names(mypoints) <- c("A", "B", "C")

plot.new()
plot.window(c(0.5, 3.5), c(0.5, 1.5))
points(mypoints, rep(1,3), pch=16)
text(mypoints, rep(1.1, 3), names(mypoints))
arrows(0.5, 1, 3.5, 1, length=0.1, angle=90, code=3)


mydistMat <- matrix(c(0,1,2,1,0,1,2,1,0), 3, 3)
colnames(mydistMat) <- names(mypoints)
rownames(mydistMat) <- names(mypoints)
myDistMat


mydist <- dist(mypoints)
mydist


mode(mydist)
typeof(mydist)
class(mydist)


as.matrix(mydist)


str(mydist)
attributes(mydist)

mydist2 <- dist(mypoints, upper=TRUE)
attributes(mydist)

library(ape)
tree <- read.tree("randomTree.tre")

tree

class(tree)
mode(tree)
typeof(tree)

sumamry(tree)

plot(tree)


library(raster)
rst <- raster("dem.tif")
rst


plot(rst)

## Challenge
dt <- data.frame(a=1:10, b=11:20, c=21:30)
dt
# 12. And what about data.frame? Can you check if they are really a built-in type like list or matrix?
##
