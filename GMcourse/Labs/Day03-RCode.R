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

##### 2: GPA with semilandmarks ####
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

