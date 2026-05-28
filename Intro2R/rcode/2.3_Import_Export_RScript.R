#####################################################################################
### ADVANCED COURSE OF INTRODUCTION TO R - CIBIO, 4-8 November 2019
# A. Kaliontzopoulou, A. Jesús Muñoz-Pajares, P. Tarroso, U. Enriquez-Urzelai
#####################################################################################


# The workspace is everything you did in your current R working environment including 
# objects, libraries, options... At the end of a session, you will be able to save the 
# entire workspace. Doing that, all the objects you created will be available the next 
# time you will run R again. 

# NOTE: Remember that in many cases it is better to save and re-run the "clean script" 
# instead of storing the entire command history, probably containing many steps with errors
# and objects that probably you will not remember being defined.

ls()

# Let's create some objects:
a <- 1
b <- "letter b"
d <- matrix(3, 4)
f <- function(x){x*3}
ls()

# You can remove objects using rm().

# To remove only one object:
rm("a") # it works with and without quotes
rm(b)

# To remove several objects in a single step you can type the names of all of them:
rm("d", "f")

# Let's create the same objects again:
a <- 1
b <- "letter b"
d <- matrix(3, 4)
f <- function(x){x*3}
ls()

# To remove all the elements without typing their names:
  
rm(list=ls())
ls()

########################
## Working directory
########################

# The working directory is a folder in your computer where R will save and load files. 
# Two functions are key at this point.

# To know which your current working directory is:
getwd()

# To change your working directory to other folder:
setwd("complete/or/partial/path/to/folder")

# Be careful with bars in the path if you are using WINDOWS. 
# `\` and `/` mean different things. R uses `\` as an "escape" character (e.g., `"\t"`). 
# For that, in windows, you may type paths as 
# "c:\\users\\mydocuments\\file.R" or "c:/users/mydocuments/file.R".


# To see the files contained in the working directory folder use: 
list.files()

# And in any other folder:
list.files("~/Documents/")


################################
## Importing / Exporting data
################################

# Import data matrices from Excel

# The most simple way is by saving the excel file as a plain text file 
# (separated by ",", ";", "tab", ...). 

# IMPORTANT! Names must include file extensions, even if you are not able to see 
# them in some operating systems (e.g. windows).

read.table(file="2.3_Import/Example1_vector.txt")

# You can read the table by defining the file's complete path (as above) 
# or you can set the working directory before and read directly from the folder:
setwd("2.3_Import/")
read.table("Example1_vector.txt")

?read.table

# Now read an example matrix:
Matrix1 <- read.table("Example2_Matrix.txt")
str(Matrix1)



Matrix2 <- read.table("Example2_Matrix.txt", header=T)
str(Matrix2)

# As the first column is a factor, you can not multiply the matrix by a number (e.g. 7):
head(Matrix1*7)
head(Matrix2*7)



Matrix3 <- read.table("Example2_Matrix.txt", header=T, dec=",")
str(Matrix3)

head(Matrix3*7)



CO2.1 <- read.table("Example3_CO2.txt", header=T, dec=",")



CO2.2 <- read.table("Example3_CO2.txt", header=T, dec=".", sep=";", 
                    row.names=1)

# After opening (and working with the data) you can save the data in your computer. 
# Again check all the options available, that are almost the same than before.
?write.table

# For conveniency we can save the object CO2.2, with NA, separator as space, 
# and without row names:
write.table(CO2.2, file="New_CO2_2.txt", sep=" ", dec=".", na="NA")


write.table(CO2.2, file="~/Dropbox/New_CO2_2.txt", sep=" ", 
            dec=".", na="NA")

# REMEMBER: If you need to read/save a file that is in a different folder, 
# you may either set your working directory to this folder or include the entire path 
# when inporting/exporting.



################
## Exercises
################

1. Download the "import_export_exercise.zip" file and uncompress it.
2. Change the working directory to the folder "import_export_exercise".
2. Read and create objects using the example files contained in the folder "Exercise_Import".
3. Save them to the folder "Exercise_Export"

# In all cases, save files using commas as column separator with column names 
# and without row names.


# There are also specific packages for reading excel files, as also for 
# reading phylogenetic trees, microsatellite data, etc. 
# Check the help file of each function before using them!

# read.csv(file, header = TRUE, sep = ", ", quote = "\"",
# dec = ".", fill = TRUE, comment.char = "", ...)
# 
# read.csv2(file, header = TRUE, sep = ";", quote = "\"",
# dec = ", ", fill = TRUE, comment.char = "", ...)
# 
# read.delim(file, header = TRUE, sep = "\t", quote = "\"",
# dec = ".", fill = TRUE, comment.char = "", ...)
# 
# read.delim2(file, header = TRUE, sep = "\t", quote = "\"",
# dec = ", ", fill = TRUE, comment.char = "", ...)


