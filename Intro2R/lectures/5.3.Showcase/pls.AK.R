### A.Kaliontzopoulou, 10 May 2015
# Function written for testing performance - morphology associations
# Scales by default
# Runs permutation of x and y to test for the correlation between PLS vectors
# Makes plots of x~y and correlations of x~Xscores, y~Yscores

pls.AK <- function(Xdata, Ydata, scale=TRUE, nperm=999){
  require(pls)
  if (scale==FALSE) { x <- Xdata; Y <- Ydata }
  else { x <- scale(Xdata); y <- scale(Ydata)}

  pls.data <- plsr(y~x, method="oscorespls")
  pls.X <- pls.data$scores[,1]
  pls.Y <- pls.data$Yscores[,1]
  cor.obs <- cor(pls.X, pls.Y)

  # Permutation to test for the observed correlation
  p.val <- 1
  for (i in 1:nperm){
    permY <- y[sample(nrow(y), replace=F),]
    rand.pls <- plsr(permY~x, method="oscorespls")
    cor.rand <- cor(rand.pls$scores[,1], rand.pls$Yscores[,1])
    p.val <- ifelse(cor.rand>=cor.obs, p.val+1, p.val)
    }
  p.val <- p.val/(1+nperm)

  pls.res <- list()
  pls.res$Xscores <- pls.X
  pls.res$Yscores <- pls.Y
  pls.res$obs.cor <- cor.obs
  pls.res$p.perm <- p.val
  return(pls.res)
}






