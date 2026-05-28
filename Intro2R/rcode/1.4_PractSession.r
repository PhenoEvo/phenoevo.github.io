####################################################################
### ADVANCED COURSE OF INTRODUCTION TO R - CIBIO, 6-10 NOVEMBER 2017
### Data types II: data frames, lists, and other data types
# Authors: P. Tarroso and A. Kaliontzopoulou
####################################################################

##### Questions and challenges #####
# 1) Try to organize the script below acordingly to the guidelines
####################################



pnt=read.table("1.4_points.txt",header=TRUE, 
sep=";")

fit<- lm(y ~ x,             data=pnt)
    y.hat=predict(fit); y.bar <-mean(pnt$y)
r_squared=sum(
(y.hat -y.bar)**   2)/
sum((pnt$y-y.bar)**2)

nodes <- rbind(c(1,2),
c(4,3),c(2,3),c(3,5),c(2,5),
c(5,9),c(9,10),c(5,6),
c(6,7),
c(7,8),
c(8,6),c(5,11),c(11,12),c(12,13),
c(13,14),c(13,15),
c(13,19),
c(19,16),c(16,13),c(16,18),
c(18,17),c(17,16),
c(19,20))

layout(matrix(c(1,3,2,3), 2, 2), 
heights=c(3,1))
plot.new()
plot.window(c(30,205),c(0,220))


points(pnt,     cex=      1, 
                pch=    16)
abline(fit, lwd=3, 
col='red')
txt=bquote(R^2 == .(round(r_squared, 2)))
mtext(txt, 1, -2, col='red')
box()





















plot.new()
plot.window(c(30,   205), c(0,     220))
points(pnt, cex = 1, pch  = 16)
for (i in 1:nrow(nodes)) {nds=nodes[i, ]
lines(pnt[nds,1], pnt[nds,2], col='red', lwd=2)}
mtext("Rexthor, the dog-bearer", 1, -2, col='red')
box()

plot.new()
mtext("I don't trust linear regressions when it's harder",1,-5, cex=2)
mtext("to guess the direction of the correlation from the",1,-3, cex =2)
mtext("scatter plot than to find new constelations on it.",1,-1,cex= 2)
mtext("(adapted from xkcd.com/1725)",1,0)




