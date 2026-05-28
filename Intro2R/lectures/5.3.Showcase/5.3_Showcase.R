# Code for analyses included in Zagar et al. 2017 Funct. Ecol.
# A. Kaliontzopoulou

rm(list=ls())
setwd("/Users/antigoni/antigua/Courses/BIODIV/2017-2018/Intro2R/AK lectures/5.3. Showcase/")

data <- read.table("data.csv", sep=",", header=T, na.strings="NA")
data <- data[!is.na(data$MAXBITE),]
colnames(data)[14:15] <- c("FLL", "HLL")
View(data)

### Replace missing values for morphology by group mean
for (m in (7:15)){
  md <- which(is.na(data[,m]))
  for (i in md){
    data[i,m] <- mean(na.exclude(data[data$SP==data$SP[i] & data$SEX==data$SEX[i], m]))
  }
}

data[,4:15] <- log(data[,4:15])
morfo <- as.matrix(data[,7:15])
HS <- apply(data[,10:12], 1, mean)
names(HS) <- data$CODE
sp <- data$SP
sex <- data$SEX
table(sp, sex)


#### PCA on morphology ####
pca.all <- prcomp(na.exclude(morfo))
summary(pca.all)

pcscores.all <- pca.all$x
cor(na.exclude(morfo), pcscores.all)

# Plot
ind.col <- ifelse(sp=="IHOR", "black", "grey45")
ind.symb <- ifelse(sex=="F", 21, 22)

par(family="Times", lwd=2, mgp=c(1.75, 0.35, 0))
plot(pcscores.all[,1:2], asp=1, xlab="PC1 (42.84%)", ylab="PC2 (31.50%)", 
     cex.lab=2, font.lab=2, pch=ind.symb, col=ind.col, bg=ind.col, cex=1.5, 
     font.axis=2)

#### AN(C)OVAs - morfo ####
library(vegan)
anova.svl <- adonis(morfo[,1]~sp*sex, method="euclidean")
anovas <- cbind(anova.svl$aov.tab, "svl")
colnames(anovas)[7] <- "VAR"
anova.HS <- cbind(adonis(HS~morfo[,1]*sp*sex, method="euclidean")$aov.tab, "HS")
colnames(anova.HS)[7] <- "VAR"
anovas <- rbind(anovas, anova.HS)

for(i in 8:9){
  temp <- cbind(adonis(morfo[,i]~morfo[,1]*sp*sex, method="euclidean")$aov.tab, 
                colnames(morfo)[i])
  colnames(temp)[7] <- "VAR"
  anovas <- rbind(anovas, temp)
}

for(i in 3:7){
  temp <- cbind(adonis(morfo[,i]~HS*sp*sex, method="euclidean")$aov.tab, 
                colnames(morfo)[i])
  colnames(temp)[7] <- "VAR"
  anovas <- rbind(anovas, temp)
}
anovas
#write.table(anovas, "SEP2015/anovas.morpho.txt", sep=",")

# Plots morfo
SPbySEX <- as.factor(paste(sp, sex, sep="."))
lsm.svl <- tapply(morfo[,1], SPbySEX, mean)
sd.svl <- tapply(morfo[,1], SPbySEX, sd)
n.svl <- as.numeric(table(SPbySEX))
min.svl <- lsm.svl-1.96*sd.svl/sqrt(n.svl)
max.svl <- lsm.svl+1.96*sd.svl/sqrt(n.svl)

#pdf("morphology.pdf")
# SVL means
par(family="Times", mgp=c(2, 0.5, 0), lwd=2)
sp.col <- c(rep("black", 2), rep("grey45", 2))
x <- c(1, 1.2, 1.7, 1.9)
plot(x, lsm.svl, xlim=c(0.8, 2.1), ylim=c(3.95, 4.15), type="n", xaxt="n", xlab="", 
     ylab="log(SVL)", cex.lab=2.5, font.lab=2, font.axis=2, cex.axis=1.25)
for (i in 1:length(lsm.svl)){
  arrows(x[i], min.svl[i], x[i], max.svl[i], length=0.15, angle=90, code=3, col=sp.col[i], lwd=3)
}
points(x, lsm.svl, pch=c(21, 22, 21, 22), cex=3, col=sp.col, bg=sp.col)
axis(1, c(1.1, 1.8), labels=c("I. horvathi", "P. muralis"), font.axis=4, cex.axis=2, tick=F)

# HS vs. SVL
par(family="Times", mgp=c(2, 0.75, 0), lwd=2)
plot(HS~morfo[,1], pch=ind.symb, bg=ind.col, col=ind.col, xlab="log(SVL)", ylab="Head size",
     cex.lab=2, font.lab=2, font.axis=2, cex=1.25)
abline(lm(HS[sp=="IHOR"&sex=="F"]~morfo[sp=="IHOR"&sex=="F",1]), lwd=4, lty=2)
abline(lm(HS[sp=="IHOR"&sex=="M"]~morfo[sp=="IHOR"&sex=="M",1]), lwd=4)
abline(lm(HS[sp=="PMUR"&sex=="F"]~morfo[sp=="PMUR"&sex=="F",1]), lwd=4, lty=2, col="grey45")
abline(lm(HS[sp=="PMUR"&sex=="M"]~morfo[sp=="PMUR"&sex=="M",1]), lwd=4, col="grey45")

# HW vs. HS
par(family="Times", mgp=c(2, 0.75, 0), lwd=2)
plot(morfo[,"HW"]~HS, pch=ind.symb, bg=ind.col, col=ind.col, xlab="Head size", ylab="log(HW)",
     cex.lab=2, font.lab=2, font.axis=2, cex=1.25)
abline(lm(morfo[sp=="IHOR","HW"]~HS[sp=="IHOR"]), lwd=4)
abline(lm(morfo[sp=="PMUR","HW"]~HS[sp=="PMUR"]), lwd=4, col="grey45")

# HH vs. HS
par(family="Times", mgp=c(2, 0.75, 0), lwd=2)
plot(morfo[,"HH"]~HS, pch=ind.symb, bg=ind.col, col=ind.col, xlab="Head size", ylab="log(HH)",
     cex.lab=2, font.lab=2, font.axis=2, cex=1.25)
abline(lm(morfo[sp=="IHOR","HH"]~HS[sp=="IHOR"]), lwd=4)
abline(lm(morfo[sp=="PMUR","HH"]~HS[sp=="PMUR"]), lwd=4, col="grey45")

# TRL vs. SVL
par(family="Times", mgp=c(2, 0.75, 0), lwd=2)
plot(morfo[,"TRL"]~morfo[,1], pch=ind.symb, bg=ind.col, col=ind.col, xlab="log(SVL)", ylab="log(TRL)",
     cex.lab=2, font.lab=2, font.axis=2, cex=1.25)
abline(lm(morfo[,"TRL"][sp=="IHOR"&sex=="F"]~morfo[sp=="IHOR"&sex=="F",1]), lwd=4, lty=2)
abline(lm(morfo[,"TRL"][sp=="IHOR"&sex=="M"]~morfo[sp=="IHOR"&sex=="M",1]), lwd=4)
abline(lm(morfo[,"TRL"][sp=="PMUR"&sex=="F"]~morfo[sp=="PMUR"&sex=="F",1]), lwd=4, lty=2, col="grey45")
abline(lm(morfo[,"TRL"][sp=="PMUR"&sex=="M"]~morfo[sp=="PMUR"&sex=="M",1]), lwd=4, col="grey45")

# FLL 
fll.res <- resid(lm(morfo[,"FLL"]~morfo[,1]))
lsm.fll <- tapply(fll.res, SPbySEX, mean)
sd.fll <- tapply(fll.res, SPbySEX, sd)
n.fll <- as.numeric(table(SPbySEX))
min.fll <- lsm.fll-1.96*sd.fll/sqrt(n.fll)
max.fll <- lsm.fll+1.96*sd.fll/sqrt(n.fll)

par(family="Times", mgp=c(2, 0.5, 0), lwd=2)
sp.col <- c(rep("black", 2), rep("grey45", 2))
x <- c(1, 1.2, 1.7, 1.9)
plot(x, lsm.fll, xlim=c(0.8, 2.1), ylim=c(-0.1, 0.09), type="n", xaxt="n", xlab="", 
     ylab="log(FLL)*", cex.lab=2.5, font.lab=2, font.axis=2, cex.axis=1.25)
for (i in 1:length(lsm.fll)){
  arrows(x[i], min.fll[i], x[i], max.fll[i], length=0.15, angle=90, code=3, col=sp.col[i], lwd=3)
}
points(x, lsm.fll, pch=c(21, 22, 21, 22), cex=3, col=sp.col, bg=sp.col)
axis(1, c(1.1, 1.8), labels=c("I. horvathi", "P. muralis"), font.axis=4, cex.axis=2, tick=F)

# HLL 
hll.res <- resid(lm(morfo[,"HLL"]~morfo[,1]))
lsm.hll <- tapply(hll.res, SPbySEX, mean)
sd.hll <- tapply(hll.res, SPbySEX, sd)
n.hll <- as.numeric(table(SPbySEX))
min.hll <- lsm.hll-1.96*sd.hll/sqrt(n.hll)
max.hll <- lsm.hll+1.96*sd.hll/sqrt(n.hll)

par(family="Times", mgp=c(2, 0.5, 0), lwd=2)
sp.col <- c(rep("black", 2), rep("grey45", 2))
x <- c(1, 1.2, 1.7, 1.9)
plot(x, lsm.hll, xlim=c(0.8, 2.1), ylim=c(-0.1, 0.09), type="n", xaxt="n", xlab="", 
     ylab="log(HLL)*", cex.lab=2.5, font.lab=2, font.axis=2, cex.axis=1.25)
for (i in 1:length(lsm.hll)){
  arrows(x[i], min.hll[i], x[i], max.hll[i], length=0.15, angle=90, code=3, col=sp.col[i], lwd=3)
}
points(x, lsm.hll, pch=c(21, 22, 21, 22), cex=3, col=sp.col, bg=sp.col)
axis(1, c(1.1, 1.8), labels=c("I. horvathi", "P. muralis"), font.axis=4, cex.axis=2, tick=F)

#dev.off()

##### ANCOVAs - Bite force #####
bf <- data$MAXBITE
svl <- morfo[,1]
anova.bf <- adonis(bf~sp*sex, method="euclidean")$aov.tab
bf1 <- adonis(bf~svl*sp*sex, method="euclidean")$aov.tab
bf2 <- adonis(bf~HS*sp*sex, method="euclidean")$aov.tab
BF <- rbind(anova.bf, bf1, bf2)
BF

# Plot BF variation across groups
lsm.bf <- tapply(bf, SPbySEX, mean)
sd.bf <- tapply(bf, SPbySEX, sd)
n.bf <- as.numeric(table(SPbySEX))
min.bf <- lsm.bf-1.96*sd.bf/sqrt(n.bf)
max.bf <- lsm.bf+1.96*sd.bf/sqrt(n.bf)

cor.bf <- resid(lm(bf~HS))
lsm.bf2 <- tapply(cor.bf, SPbySEX, mean)
sd.bf2 <- tapply(cor.bf, SPbySEX, sd)
min.bf2 <- lsm.bf2-1.96*sd.bf2/sqrt(n.bf)
max.bf2 <- lsm.bf2+1.96*sd.bf2/sqrt(n.bf)

layout(matrix(1:2, nrow=1))
par(family="Times", mgp=c(2, 0.5, 0), lwd=2)
sp.col <- c(rep("black", 2), rep("grey45", 2))
x <- c(1, 1.2, 1.7, 1.9)
plot(x, lsm.bf, xlim=c(0.8, 2.1), ylim=c(-0.3, 1.21), type="n", xaxt="n", xlab="", 
     ylab="log(Bite force)", cex.lab=2, font.lab=2, font.axis=2, cex.axis=1.5)
for (i in 1:length(lsm.bf)){
  arrows(x[i], min.bf[i], x[i], max.bf[i], length=0.15, angle=90, code=3, 
         col=sp.col[i], lwd=3)
  }
points(x, lsm.bf, pch=c(21, 22, 21, 22), cex=3, col=sp.col, bg=sp.col)
axis(1, c(1.1, 1.8), labels=c("Ihor", "Pmur"), font.axis=2, cex.axis=2, tick=F)

plot(x, lsm.bf2, xlim=c(0.8, 2.1), ylim=c(-0.35, 0.3), type="n", xaxt="n", xlab="", 
     ylab="log(Bite force)*", cex.lab=2, font.lab=2, font.axis=2, cex.axis=1.5)
for (i in 1:length(lsm.bf2)){
  arrows(x[i], min.bf2[i], x[i], max.bf2[i], length=0.15, angle=90, code=3, 
         col=sp.col[i], lwd=3)
}
points(x, lsm.bf2, pch=c(21, 22, 21, 22), cex=3, col=sp.col, bg=sp.col)
axis(1, c(1.1, 1.8), labels=c("Ihor", "Pmur"), font.axis=2, cex.axis=2, tick=F)

##### BF and head shape #####
source("pls.AK.R")
head <- NULL
for (i in 3:7){
  temp <- resid(lm(morfo[,i]~HS))
  head <- cbind(head, temp)
}
colnames(head) <- colnames(morfo)[3:7]

pls.bf <- pls.AK(head, cor.bf)
pls.bf$obs.cor; pls.bf$p.perm

corsX <- cor(head, pls.bf$Xscores)
corsX

# Plot
layout(matrix(1:2, nrow=2, byrow=T), heights=c(3.5, 1.5))

par(family="Times", mgp=c(0.5, 0, 0), pin=c(4.25, 4.25), lwd=2, xpd=T)
plot(pls.bf$Yscores~pls.bf$Xscores, pch=ind.symb, bg=ind.col, col=ind.col, 
     cex=1.25, xlab="PLS Scores - Head shape", ylab="PLS Scores - Bite force", 
     cex.lab=1.75, font.lab=2, xaxt="n", yaxt="n", lwd=2)

par(mgp=c(2, 0.5, 0), mar=c(3, 8, 1, 8)+0.1)
barplot(corsX, horiz=T, beside=T, space=0.2, names.arg=rownames(corsX),family="Times", 
        font=2, lwd=2, xlim=c(-1, 1), col="snow3", las=1, cex.axis=1, cex.names=1.25, 
        xlab="Correlations with variables", cex.lab=1.5, font.lab=2, bg="transparent")
