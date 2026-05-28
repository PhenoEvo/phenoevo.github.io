################################################################################
### ADVANCED COURSE OF INTRODUCTION TO R - CIBIO, 4-8 NOVEMBER 2019
### DATA TYPES: VECTORS, MATRICES AND ARRAYS
# A. Jesús Muñoz-Pajares,  A. Kaliontzopoulou, P. Tarroso, U. Enriquez-Urzelai
################################################################################

# VECTORS have one dimension
vec1 <- rnorm(10)
vec1
dim(vec1)
length(vec1)

vec1[2]
vec1[2:5]
vec1[-1]
vec1[c(2, 5, 7)]

vec1[vec1<0.5]				
vec1<0.5
which(vec1<0.5)
vec1[vec1 < 0.5 & vec1 > -0.5]		
vec1[vec1 > 0.5 | vec1 < -0.5]
vec1[vec1>=vec1[1]]

vec2 <- as.factor(c(rep("F", 5), rep("M", 5)))
vec2
vec1.F <- vec1[vec2=="F"]
vec1.F
vec1.M <- vec1[vec2!="F"]		# Which is the same as:
vec1.M

vec1.M <- vec1[vec2==M]			
vec1.M <- vec1[vec2=="M"]
vec1.M

vec1.F2 <- subset(vec1, vec2=="F")

# MATRICES have two dimensions: rows and columns
mat1 <- matrix(rnorm(25), nrow=5)
mat1
dim(mat1)

mat1[2]
mat1[11]
mat1[1, 3]
mat1[1,]
mat1[,3]
mat1[,c(2, 5)]
mat1[,-c(1:3)]

colnames(mat1) <- c("A", "B", "C", "D", "E")
mat1
mat1[,"A"]
mat1[c(2, 1, 3, 5, 4),]
vec3 <- sample(1:5)
vec3
mat1[,vec3]

# ARRAYS have 3 fully corresponding dimensions
arr1 <- array(rnorm(100), dim=c(10, 2, 5), dimnames=list(paste("var", 1:10, sep="_"), c("M", "F"), paste("locality", 210:214, sep=".")))
arr1
str(arr1)
arr1[1,,]
arr1["var_9",,]
arr1[,"M",]
arr1[, "F", "locality.213"]

# DATAFRAMES
beav <- read.table("beavers.txt", sep=",", header=T, na="NA")
beav
str(beav)

beav[,2]
beav[,"sex"]
beav$sex
beav[["sex"]]

beav$sp
is.na(beav)
which(is.na(beav))
beav.complete <- na.exclude(beav)
str(beav.complete)

males.sp1 <- beav[beav$sex=="M" & beav$sp=="sp1"]
males.sp1 <- beav[beav$sex=="M" & beav$sp=="sp1",]
str(males.sp1)				# Careful with unused factor levels
males.sp1$sex
levels(males.sp1$sex)
males.sp1$sex <- droplevels(males.sp1$sex)
levels(males.sp1$sex)

# LISTS
ls1 <- list(arr1, beav, beav.complete, vec2, mat1)
names(ls1) <- c("arr1", "beavers", "beavers.complete", "vec2", "mat1")

ls1[[4]]
ls1$beavers
ls1[["arr1"]][,"F",]




