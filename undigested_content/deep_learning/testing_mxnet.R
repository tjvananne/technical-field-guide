

# testing a neural network

# this is old, but it is still really great:
# http://dmlc.ml/rstats/2015/11/03/training-deep-net-with-R.html


# actual CRAN reference guide for this package:
# http://mxnet.io/api/r/mxnet-r-reference-manual.pdf



# install.packages("drat", repos="https://cran.rstudio.com")
# drat:::addRepo("dmlc")
# install.packages("mxnet")
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


# that was dumb....
rm(list=ls())


