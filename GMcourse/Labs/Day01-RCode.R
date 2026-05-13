# This R script contains the concatenated code from the day 1 tutorials.
# This is what you should work through during lab, using your own data.

##### 1: Digitizing in StereoMorph
install.packages("StereoMorph")
library(StereoMorph)
library(geomorph)

# Landmark digtizing: see Tutorial for additional instructions
digitizeImages(image.file='Images', shapes.file='Shapes',
               landmarks.ref=paste("LM", c(1:5), sep=""))

# Scaling: See Tutorial for instructions

# Read Data

shapes <- readShapes("Shapes") # Steromorph function.  Turns image txt files into a list
shapesGM <- readland.shapes(shapes) # geomorph conversion function

# GPA (more below)

Y.gpa <- gpagen(shapesGM)
plot(Y.gpa)

# Digitizing a curve (add to existing LMs)

digitizeImages(image.file='Images', shapes.file='Shapes',
               landmarks.ref=paste("LM", c(1:5), sep=""),
               curves.ref = "example.curves.txt")

# Read Data

shapes <- readShapes("Shapes") # Steromorph function.  Turns image txt files into a list
shapesGM <- readland.shapes(shapes, nCurvePts = 10) # geomorph conversion function

# GPA

Y.gpa <- gpagen(shapesGM)
plot(Y.gpa)

#### 2 Read Data

# Working with digitized specimens (StereoMorph)
# These 30 specimens have 11 fixed landmarks and 6 curves

shapes <- readShapes("example.digitized")

# curves include eye, head, tail1, tail end, tail2, anal fin, 
# pectoral fin, opercle, pre-opercle
curves.list <- c(20, 24, 24, 16, 12, 8, 8, 24, 16)
shapesGM <- readland.shapes(shapes, nCurvePts = curves.list)

Y.gpa <- gpagen(shapesGM)
plot(Y.gpa)

# Too many semilandmarks?
shapesGM <- readland.shapes(shapes, nCurvePts = 0.5 * curves.list)

Y.gpa <- gpagen(shapesGM)
plot(Y.gpa)

# Attributes
class(shapesGM)
attributes(shapesGM)

shapesGM$fixed
shapesGM$curves
shapesGM$landmarks[[1]] # specimen 1
names(shapesGM$landmarks)


# Read TPS File
mydata <- readland.tps("Data/salamanders.tps")
str(mydata)
dim(mydata)  # file contains 287 specimens with 12 landmarks each of 2D data
mydata[,,1]

mydata <- readland.tps("Data/salamanders.tps", specID="imageID") # Specify specimen labels
str(mydata)
mydata[,,1:2]

# Read NTS File
mydata <- readland.nts("Data/RATS.nts")
str(mydata)
mydata[,,1]

# Read PLY
library(rgl)
new <- read.ply("Data/Mandible.ply")
str(new)

# Read CSV
food <- read.csv("Data/food.csv", header=TRUE, row.names=1)
str(food)
food[1:2,]

# Read Phylogeny
library(ape)
mytree <- read.tree("Data/plethtree.tre")
plot(mytree)

##### 3: Data Pre-Processing

# Check for Outliers
data(plethodon)
newland <- plethodon$land
newland[c(1,8),,2] <- newland[c(8,1),,2]
newland[c(3,11),,26] <- newland[c(11,3),,2]
Y <- gpagen(newland, print.progress = FALSE) 

plotOutliers(Y$coords, inspect.outliers = T)

# Fixed Angle
jaw.fixed <- fixed.angle(Y$coords,
                         art.pt=1, angle.pts.1 = 5, 
                         angle.pts.2 = 6, rot.pts = c(2,3,4,5))

gpa.fixed <- gpagen(jaw.fixed, print.progress = FALSE)
plotAllSpecimens(gpa.fixed$coords, links = plethodon$links)

# Estimate Missing Landmarks
#### build some missing data (EXAMPLE ONLY)
data(plethodon)
plethland <- plethodon$land
plethland[3,,2] <- plethland[8,,2] <- NA  #create missing landmarks
plethland[3,,5] <- plethland[8,,5] <- plethland[9,,5]<-NA  
plethland[3,,10] <- NA  

# Estimate via TPS or Regression
estimate.missing(plethland,method="TPS")
estimate.missing(plethland,method="Reg")

##### 4: Generalized Procrustes Analysis: GPA
data(plethodon)
pleth.gpa <- gpagen(plethodon$land, print.progress = F)
summary(pleth.gpa)

plot(pleth.gpa)
plotAllSpecimens(pleth.gpa$coords, links = plethodon$links)
