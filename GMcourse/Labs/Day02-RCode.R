# This R script contains the concatenatid code from the day 3 tutorials.
# This is what you should work through during lab, using your own data.

library(geomorph)

##### 1: ANOVA and pairwise comparisons ==============================================================

data(plethodon) # SOME EXAMPLE DATA
Y.gpa <- gpagen(plethodon$land, print.progress = FALSE)  
plot(Y.gpa)

gdf <- geomorph.data.frame(Y.gpa, 
                           site = plethodon$site, 
                           species = plethodon$species,
                           gp = interaction(plethodon$species, plethodon$site)) # geomorph data frame
# Single-Factor ANOVA
pleth.anova <- procD.lm(coords ~ species, data = gdf, print.progress = FALSE)
anova(pleth.anova)
PCA <- gm.prcomp(Y.gpa$coords)
plot(PCA, pch = 21, bg = gdf$species)

# Before going further, let's look at some of the attributes of procD.lm object.
# This will help to understand how a lot of downstream analyses work.

attributes(pleth.anova)

# The objects, $call, $LM, $ANOVA, and $PermInfo are generated from the lm.rrpp function in the 
# RRPP package.  The preceding objects are all found in these RRPP objects, or calculated from them,
# and are retained this way for historical consideration 
# (they were generated before procD.lm depended on RRPP).
# The $GM object is a new feature (since geomorph version 3.1.0).  
# When data are GM data (landmarks in 3D arrays),
# the $GM object will arrange fitted values, residuals, and coefficients into the 3D format 
# for shape prediction.  For example:

pleth.anova$GM$fitted[,, 1:4]
pleth.anova$GM$residuals[,, 1:4]
pleth.anova$GM$coefficients # effects

# Let's see the species effect as a TPS plot 

ref <- mshape(Y.gpa$coords)

par(mfcol = c(1, 2))

# P. jordani (just the intercept; i.e., 1, 0)
plotRefToTarget(ref,  pleth.anova$GM$coefficients[,, 1], mag = 3)
mtext("P. jordani")

# P. teyahelee (intercept + slope; i.e., 1, 1)
plotRefToTarget(ref,  pleth.anova$GM$coefficients[,, 1] + pleth.anova$GM$coefficients[,, 2], mag = 3)
mtext("P. teyahalee")
par(mfcol = c(1,1))

### --------------------------------------------------------------------------------------------------

# MANOVA statistics

pleth.manova <- manova.update(pleth.anova, tol = 0)
summary(pleth.manova)
summary(pleth.manova, test = "Pillai")
summary(pleth.manova, test = "Wilks")


### --------------------------------------------------------------------------------------------------

# Factorial Models with Pairwise Comparisons
pleth.anova2 <- procD.lm(coords ~ species*site, data = gdf, print.progress = FALSE)
anova(pleth.anova2)

# Before performing pairwise comparisons, it might be useful to see what the null model is
reveal.model.designs(pleth.anova2)

pleth.pw <- pairwise(pleth.anova2, groups = gdf$gp)
summary(pleth.pw, confidence = 0.95, test.type = "dist")

# We could override the null model, if we wanted

pleth.null <- procD.lm(coords ~ 1, data = gdf, print.progress = FALSE)
pleth.pw2 <- pairwise(pleth.anova2, fit.null = pleth.null, groups = gdf$gp)
summary(pleth.pw2, confidence = 0.95, test.type = "dist")

# Note that the former paiwise test considered whether means were different, given species 
# and site differences.  The latter pairwise test considered whether means were different, 
# given the overall mean was sufficient as a null model.

### --------------------------------------------------------------------------------------------------

## plots
pleth.raw <- gm.prcomp(Y.gpa$coords)
gps <- as.factor(paste(plethodon$species, plethodon$site))
plot(pleth.raw, pch=22, cex = 1.5, bg = gps) 
#  Add things as desired using standard R plotting
legend("topleft", pch=22, pt.bg = unique(gps), legend = levels(gps))

M <- mshape(Y.gpa$coords)
pleth.anova <- procD.lm(coords ~ species*site, data=gdf, print.progress = FALSE)
X <- pleth.anova$X
X[1:10,] # includes intercept; remove for better functioning 
X <- X[,-1]
symJord <- c(0,1,0) # design for P. Jordani in sympatry
alloJord <- c(0,0,0) # design for P. Jordani in allopatry
preds <- shape.predictor(pleth.anova$GM$fitted, x = X, Intercept = TRUE, 
                         symJord=symJord, alloJord=alloJord)
plotRefToTarget(M, preds$symJord, links = plethodon$links, mag=2)
plotRefToTarget(M, preds$alloJord, links = plethodon$links, mag=2)

# via picknplot
par(mar = c(5, 5, 2, 2))
pleth.anova.plot <- plot(pleth.anova, type = "PC", pch = 21, 
                         bg = interaction(gdf$species, gdf$site))
picknplot.shape(pleth.anova.plot)

### --------------------------------------------------------------------------------------------------

## Nested Models (i.e., error term adjustment)
data("larvalMorph")
Y.gpa <- gpagen(larvalMorph$tailcoords, curves = larvalMorph$tail.sliders,
                ProcD = TRUE, print.progress = FALSE)
gdf <- geomorph.data.frame(Y.gpa, treatment = larvalMorph$treatment, 
                           family = larvalMorph$family)

fit <- procD.lm(coords ~ treatment/family, data = gdf, 
                print.progress = FALSE, iter = 199)
anova(fit) # treatment effect not adjusted
anova(fit, error = c("treatment:family", "Residuals")) # treatment effect updated (adjusted)

##### 2: Allometry ===================================================================================

# Simple Allometry
data(plethodon) 
Y.gpa <- gpagen(plethodon$land, print.progress = FALSE)    #GPA-alignment  
gdf <- geomorph.data.frame(Y.gpa, site = plethodon$site, 
                           species = plethodon$species) 
fit <- procD.lm(coords ~ log(Csize), data=gdf, iter=999, print.progress = FALSE)
anova(fit)

# Predline
plotAllometry(fit, size = gdf$Csize, logsz = TRUE, method = "PredLine", pch = 19)

# RegScore
plotAllometry(fit, size = gdf$Csize, logsz = TRUE, method = "RegScore", pch = 19)

# CAC
plotAllometry(fit, size = gdf$Csize, logsz = TRUE, method = "CAC", pch = 19)

### --------------------------------------------------------------------------------------------------

# Group Allometry, including homogeneity of slopes test

fit.unique <- procD.lm(coords ~ Csize * species * site, data=gdf, iter=999, print.progress = FALSE)
fit.common <- procD.lm(coords ~ Csize + species * site, data=gdf, iter=999, print.progress = FALSE)
anova(fit.common, fit.unique)

# Because the unique slopes model was slightly better, it seems unwise to assume slopes
# are parallel and compare means.  However, the additional explained variation with unique slopes 
# was also quite small.
# Let's see what happens when we compare slopes.
# We can compare slopes with pairwise, just like means.
# Let's make sure the common slopes model is the null model.

### --------------------------------------------------------------------------------------------------

# Pairwise comparisons
slope.pw <- pairwise(fit.unique, fit.null = fit.common, 
                     groups = interaction(gdf$species, gdf$site),
                     covariate = gdf$Csize)
summary(slope.pw, test.type = "VC", angle.type = "deg") # angular differences
summary(slope.pw, test.type = "dist", angle.type = "deg") # amount of shape change differences

# Conclusion: some slight differences in angles between slopes
# Note that the UCL angles are quite large - usually an indication of 
# small size ranges.

### --------------------------------------------------------------------------------------------------
# Plots

# Predline
plotAllometry(fit.unique, size = gdf$Csize, logsz = TRUE, method = "PredLine", 
              pch = 19, col = as.numeric(interaction(gdf$species, gdf$site)))

# RegScore
plotAllometry(fit.unique, size = gdf$Csize, logsz = TRUE, method = "RegScore", 
              pch = 19, col = as.numeric(interaction(gdf$species, gdf$site)))


# Size-Shape Space
pc.plot <- plotAllometry(fit.unique, size = gdf$Csize, logsz = TRUE, method = "size.shape", 
                         pch = 19, col = as.numeric(interaction(gdf$species, gdf$site)))
summary(pc.plot$size.shape.PCA)

# with picknplot.shape

picknplot.shape(pc.plot)

dev.off()
### --------------------------------------------------------------------------------------------------

##### 3: Visualizing Shape Differences and PCA ####

# Plotting all specimens
data(plethodon)
Y.gpa <- gpagen(plethodon$land, print.progress = F)    # GPA-alignment

par(mfrow=c(1,2)) 
plotAllSpecimens(plethodon$land, links=plethodon$links)  # Raw data
mtext("Raw Data")
plotAllSpecimens(Y.gpa$coords, links=plethodon$links)    # GPA-aligned data
mtext("GPA-Aligned Specimens")
par(mfrow=c(1,1)) 

# Types of deformations
ref <- mshape(Y.gpa$coords)
par(mfrow=c(3,2))
plotRefToTarget(ref,Y.gpa$coords[,,39], links=plethodon$links)
mtext("TPS")
plotRefToTarget(ref,Y.gpa$coords[,,39],mag=2.5, links=plethodon$links)
mtext("TPS: 2.5X magnification")

plotRefToTarget(ref,Y.gpa$coords[,,39], links=plethodon$links,method="vector",mag=3)
mtext("Vector Displacements")
plotRefToTarget(ref,Y.gpa$coords[,,39], links=plethodon$links,gridPars=gridPar(pt.bg="red", link.col="green", pt.size = 1),
                method="vector",mag=3)
mtext("Vector Displacements: Other Options")

plotRefToTarget(ref,Y.gpa$coords[,,39],mag=2,outline=plethodon$outline)  
mtext("Outline Deformation")
plotRefToTarget(ref,Y.gpa$coords[,,39],method="points",outline=plethodon$outline)
mtext("OUtline Deformations Ref (gray) & and Tar (black)")
par(mfrow=c(1,1))

# Shape Predictions
# PCA-based
M <- mshape(Y.gpa$coords)
PCA <- gm.prcomp(Y.gpa$coords)
PC <- PCA$x[,1]
preds <- shape.predictor(Y.gpa$coords, x= PC, Intercept = FALSE, 
                         pred1 = min(PC), pred2 = max(PC)) # PC 1 extremes, more technically
plotRefToTarget(M, preds$pred1, links = plethodon$links)
mtext("PC1 - Min.")
plotRefToTarget(M, preds$pred2, links = plethodon$links)
mtext("PC1 - Max.")

# Regression-based
gdf <- geomorph.data.frame(Y.gpa)
plethAllometry <- procD.lm(coords ~ log(Csize), data=gdf, print.progress = FALSE)
allom.plot <- plot(plethAllometry, 
                   type = "regression", 
                   predictor = log(gdf$Csize),
                   reg.type ="PredLine") # make sure to have a predictor 

preds <- shape.predictor(plethAllometry$GM$fitted, x= allom.plot$RegScore, Intercept = FALSE, 
                         predmin = min(allom.plot$RegScore), 
                         predmax = max(allom.plot$RegScore)) 
plotRefToTarget(M, preds$predmin, mag=3, links = plethodon$links)
plotRefToTarget(M, preds$predmax, mag=3, links = plethodon$links)

# via picknplot.shape (more detail below)
picknplot.shape(allom.plot) 

# Group difference-based
gdf <- geomorph.data.frame(Y.gpa, species = plethodon$species, site = plethodon$site)
pleth.anova <- procD.lm(coords ~ species*site, data=gdf, print.progress = FALSE)
X <- pleth.anova$X
X # includes intercept; remove for better functioning 
X <- X[,-1]
symJord <- c(0,1,0) # design for P. Jordani in sympatry
alloJord <- c(0,0,0) # design for P. Jordani in allopatry
preds <- shape.predictor(pleth.anova$GM$fitted, x = X, Intercept = TRUE, 
                         symJord=symJord, alloJord=alloJord)
plotRefToTarget(M, preds$symJord, links = plethodon$links, mag=2)
plotRefToTarget(M, preds$alloJord, links = plethodon$links, mag=2)

# via picknplot.shape (more detail below)
plot.anova <- plot(pleth.anova, type = "PC", pch = 21, 
                   bg = interaction(gdf$species, gdf$site), 
                   asp = 1)

picknplot.shape(plot.anova) 

##### 3: Principal Components Analysis (PCA)
pleth.raw <- gm.prcomp(Y.gpa$coords)
gps <- as.factor(paste(plethodon$species, plethodon$site))
plot(pleth.raw)
par(mar=c(2, 2, 2, 2))
plot(pleth.raw, pch=22, cex = 1.5, bg = gps) 
#  Add things as desired using standard R plotting
legend("topleft", pch=22, pt.bg = unique(gps), legend = levels(gps))

##### 4: PickNPlot Shapes in Real Time (more detail here)
data(plethodon) 
Y.gpa <- gpagen(plethodon$land)
pleth.pca <- gm.prcomp(Y.gpa$coords)

pleth.pca.plot <- plot(pleth.pca)
picknplot.shape(pleth.pca.plot) 

picknplot.shape(plot(pleth.pca), method = "points", mag = 3, links=plethodon$links)

##### 5: 3D Warping
scallops <- readland.tps("Data/scallops for viz.tps", specID = "ID")
ref <- mshape(scallops)
refmesh <- warpRefMesh(read.ply("Data/glyp02L.ply"), 
                       scallops[,,1], ref, color=NULL, centered=T)
