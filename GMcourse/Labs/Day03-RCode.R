# This R script contains the concatenated code from the day 4 tutorials.
# This is what you should work through during lab, using your own data.

library(geomorph)

##### 1: Asymmetry ###
## matching symmetry
data(mosquito)
str(mosquito)
mosq.sym <- bilat.symmetry(mosquito$wingshape, 
                           ind = mosquito$ind, side = mosquito$side,
                           replicate = mosquito$replicate, 
                           object.sym = FALSE, print.progress = FALSE)
summary(mosq.sym)
plot(mosq.sym)

## object symmetry
data(scallops)
str(scallops)
plot(mshape(scallops$coorddata))
scallops$land.pairs

scallop.sym <- bilat.symmetry(scallops$coorddata, 
                              ind = scallops$ind, object.sym = TRUE,
                              land.pairs = scallops$land.pairs, 
                              print.progress = FALSE)
summary(scallop.sym)
plot(scallop.sym)

##### 2: Articulated structures ##### 
# Fixed Angle
data(plethodon)
Y <- gpagen(plethodon$land) 
plot(Y, links = plethodon$links)

jaw.fixed <- fixed.angle(Y$coords,
                         art.pt=1, angle.pts.1 = 5, 
                         angle.pts.2 = 6, rot.pts = c(2,3,4,5))

gpa.fixed <- gpagen(jaw.fixed, print.progress = FALSE)
plotAllSpecimens(gpa.fixed$coords, links = plethodon$links)

##### 3: GPA with semilandmarks ####
# Fixed points only
data(plethodon)
pleth.gpa <- gpagen(plethodon$land, print.progress = F)
summary(pleth.gpa)

plot(pleth.gpa)
plotAllSpecimens(pleth.gpa$coords, links = plethodon$links)

# Points and Curve points
data(hummingbirds)
hummingbirds$curvepts   
gpa.BE <- gpagen(hummingbirds$land, curves=hummingbirds$curvepts, ProcD=FALSE, print.progress = F)
plot(gpa.BE)

gpa.procD <- gpagen(hummingbirds$land, curves=hummingbirds$curvepts, ProcD=TRUE, print.progress = F)
plot(gpa.procD)

# Points, Curves, and Surfaces
data(scallops)
scallops$surfslide  
gpa.scallop <- gpagen(A=scallops$coorddata, curves=scallops$curvslide, surfaces=scallops$surfslide, print.progress = F)
plot(gpa.scallop)

# Points and curves via readland.shapes
library(StereoMorph)
shapes <- readShapes("example.digitized")
shapesGM <- readland.shapes(shapes, 
                            nCurvePts = c(12, 12, 12, 8, 6, 6, 6, 12, 10))

shapesGM$curves
gpa.pupfish <- gpagen(shapesGM)
plot(gpa.pupfish)

##### 4: Estimate Missing Landmarks ####
#### build some missing data (EXAMPLE ONLY)
data(plethodon)
plethland <- plethodon$land
plethland[3,,2] <- plethland[8,,2] <- NA  #create missing landmarks
plethland[3,,5] <- plethland[8,,5] <- plethland[9,,5]<-NA  
plethland[3,,10] <- NA  

# Estimate via TPS or Regression
estimate.missing(plethland,method="TPS")
estimate.missing(plethland,method="Reg")

