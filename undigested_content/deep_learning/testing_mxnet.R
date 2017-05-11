

# testing a neural network

# this is old, but it is still really great:
# http://dmlc.ml/rstats/2015/11/03/training-deep-net-with-R.html


# actual CRAN reference guide for this package:
# http://mxnet.io/api/r/mxnet-r-reference-manual.pdf



# install.packages("drat", repos="https://cran.rstudio.com")
# drat:::addRepo("dmlc")
# install.packages("mxnet")
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(mxnet)
library(mlbench)
data(Sonar, package='mlbench')

Sonar[, 61] = as.numeric(Sonar[,61])-1

# split train and test
train.ind = c(1:50, 100:150)
train.x = data.matrix(Sonar[train.ind, 1:60])
train.y = Sonar[train.ind, 61]
test.x <- data.matrix(Sonar[-train.ind, 1:60])
test.y <- Sonar[-train.ind, 61]



mx.set.seed(0)
model <- mx.mlp(train.x, train.y, hidden_nod=10, out_node=2,
                out_activation="softmax", num.round=20, 
                array.batch.size=15, learning.rate=0.07, momentum=0.9,
                eval.metric=mx.metric.accuracy)


graph.viz(model$symbol)

preds <- predict(model, test.x)
pred.label <- max.col(t(preds)) - 1
table(pred.label, test.y)




# MNIST -------------------------------------------------------------
# that was dumb.... let's move on to an example of MNIST
rm(list=ls())

# you'll have to create this directory on whatever machine you run this from:

datapath <- 'LARGE_FILES_MNIST_data/'

train <- read.csv(file=paste0(datapath, 'train.csv'), stringsAsFactors = F, header=T)
test <- read.csv(file=paste0(datapath, 'test.csv'), stringsAsFactors = F, header=T)

?image


    # testing what an image looks like when plotted
    36918 -> this_row ; img1mat <- matrix(as.numeric(train[this_row, -1]), byrow=T, ncol=28, nrow=28); train[this_row,1]; 
    dim(img1mat)
    
    grayscale_vals <- gray((0:32) / 32)
    image(img1mat, main="raw matrix", col=grayscale_vals)
    image(img1mat[nrow(img1mat):1,], main="reversing rows, bottom to top", col=grayscale_vals)
    image(t(img1mat[nrow(img1mat):1,]), main="transpose of row reversal", col=grayscale_vals)






