
# 05-07-17: this is a super helpful question regarding batch sizes, epoch, etc.
# https://stats.stackexchange.com/questions/153531/what-is-batch-size-in-neural-network

# * one epoch = one forward pass and one backward pass of all the training examples
# * batch size = the number of training examples in one forward/backward pass. The higher 
    # the batch size, the more memory space you'll need.
# * number of iterations = number of passes, each pass using [batch size] number of 
    # examples. To be clear, one pass = one forward pass + one backward pass (we do 
    # not count the forward pass and backward pass as two different passes).


#' 05-05-17: I started with the "fuly_connected_nnet_in_raw_R file because I thought I'd be
#' learning how to code a neural net in raw R with that article, but it led me to
#' their github where I found a bunch of their implementations of NNets. I copied
#' them into that file, then found I wasn't able to clearly understand the code
#' without an incredible amount of trial and error (what class should the inputs
#' for each function be, for example). So then i found this document where they actually
#' do some testing of their NNets on the iris dataset which is what I was going to
#' do anyway, so that is where I am.


# Copyright 2016: www.ParallelR.com
# Parallel Blog : R For Deep Learning (I): Build Fully Connected Neural Network From Scratch
# Classification by 2-layers DNN and tested by iris dataset
# Author: Peng Zhao, patric.zhao@gmail.com

# Prediction
predict.dnn <- function(model, data = X.test) {
    

        model = model # this should already exist (go halfway through train function til you get to predict)
        data = testdata[,-y]
    
    # new data, transfer to matrix
    new.data <- data.matrix(data)
    
    # Feed Forwad
    hidden.layer <- sweep(new.data %*% model$W1 ,2, model$b1, '+')
    # neurons : Rectified Linear
    hidden.layer <- pmax(hidden.layer, 0)
    score <- sweep(hidden.layer %*% model$W2, 2, model$b2, '+')
    
    # Loss Function: softmax
    score.exp <- exp(score)
    probs <-sweep(score.exp, 1, rowSums(score.exp), '/') 
    
    # select max possiblity
    labels.predicted <- max.col(probs)
    return(labels.predicted)
}

# Train: build and train a 2-layers neural network 
train.dnn <- function(x, y, traindata=data, testdata=NULL,
                      model = NULL,  # the user can pass in a pre-built model?
                      # set hidden layers and neurons
                      # currently, only support 1 hidden layer
                      hidden=c(6), 
                      # max iteration steps
                      maxit=2000,
                      # delta loss 
                      abstol=1e-2,
                      # learning rate
                      lr = 1e-2,
                      # regularization rate
                      reg = 1e-3,
                      # show results every 'display' step
                      display = 100,
                      random.seed = 1)
{
    
        # Taylor's hard-coded parameters for procedurally working through this function:
        x = 1:4  # column indeces for the non-label data
        y = 5    # column index for the label
        set.seed(1)  # set seed real quick for train test split
        mysamp = c(sample(1:50,25), sample(51:100,25), sample(101:150,25))  # stratified sampling within the Species class
        traindata = iris[mysamp,]  # training data
        testdata = iris[-mysamp,]  # testing data
        hidden=c(6)                # eventually want to experiment with many layers here, i think this is a single layer of six nodes?
        maxit=2000                 # maximum iterations?
        abstol=1e-2                # 0.01 -- what is delta loss? not sure what that is here..
        lr=1e-2                    # 0.01 -- this is the learning rate or alpha, how fast we converge on minima
        reg=1e-3                   # 0.001 -- this is how to keep from overfitting, not sure how regularization works in a NNet
        display=50                 # how often to display the results out to the console (count of iterations)
        random.seed=1              # for reproducible results, of course
        model=NULL                 # I guess users can pass in their own model? but here we'll set it to NULL so we train our own
        
    
    # to make the case reproducible.
    set.seed(random.seed)
    
    # total number of training set
    N <- nrow(traindata)  # we did a 50/50 split on a 150 row dataset, so nrow train is 75, nrow test is 75
    
    # extract the data and label
    # don't need atribute 
    X <- unname(data.matrix(traindata[,x]))    # data.matrix converts it all to numeric, then to a matrix
        
        # "as.matrix()" would have been the same, but maybe not as safe because it could end up being character matrix if you have non-numbs
        # X <- unname(as.matrix(traindata[,x]))  
        # look at the diff between:
        # as.matrix(iris) and data.matrix(iris)
    
    
    # correct categories represented by integer 
    Y <- traindata[,y]
    if(is.factor(Y)) { Y <- as.integer(Y) }  # converted to the numerical representation of the factor
    # create index for both row and col
    # create index for both row and col
    Y.len   <- length(unique(Y))             # number of unique values of Y -- maybe for number of output nodes?
    Y.set   <- sort(unique(Y))               # sort the number of unique values of Y... could have 1:Y.len unless unsure if starting at 1?
    Y.index <- cbind(1:N, match(Y, Y.set))   # I think this would only matter if they were unordered? we can test that later..
    
    
    
    # create model or get model from parameter
    if(is.null(model)) {
        
        # this is known as the architecture of the NNet, number of input nodes, output nodes, and hidden layers (and nodes per hidden layer)
        # number of input features
        D <- ncol(X)            # input nodes
        # number of categories for classification
        K <- length(unique(Y))  # output nodes
        H <-  hidden            # hidden nodes
        
            print(c(D, H, K))
        
        
        # **********W1 and b1 are the mappings between inputs and first hidden layer
            # multiplying by 0.01 compresses the range of the normally distributed random weights to start with
            
        # create and init weights and bias 
        W1 <- 0.01*matrix(rnorm(D*H), nrow=D, ncol=H)  
            # generate (number of input layers times hidden layer nodes) random numbers,
            # save that in a matrix of rows == input nodes and cols == hidden layer nodes
            # this produces normal randoms centered around zero (limits are about -0.015 and 0.015)
            # how does this work with several hidden layers?? -- let's explore that later
            # this is what the distribution looks like that we're pulling these weights from
            hist(rnorm(1000000) * 0.01, col='light blue', main='W1 weights distribution')  
        
        
        # single row of zeros with (number of hidden nodes) columns
        b1 <- matrix(0, nrow=1, ncol=H)
            # once again, what would this look like with several (or just > 1) hidden layers??
        
        
        # **********W2 and b2 are the mappings between the first hidden layer and the output layers
        
        W2 <- 0.01*matrix(rnorm(H*K), nrow=H, ncol=K)
        b2 <- matrix(0, nrow=1, ncol=K)
        
    # this is where we would assign the variables from a pre-trained model i guess?
    } else {
        D  <- model$D
        K  <- model$K
        H  <- model$H
        W1 <- model$W1
        b1 <- model$b1
        W2 <- model$W2
        b2 <- model$b2
    }
    
    # use all train data to update weights since it's a small dataset
        # what are the limits here? when do you need to update batch size?
        # are batches randomly sampled? with replacement?
    batchsize <- N
    
    
    # init loss to a very big value
        # too many questions to even list here... but I get the idea.. most likely any value will be lower than this
    loss <- 100000
    
    
    # Training the network
    i <- 0
    
    # stop if we hit max iterations or if loss dips down below abstol?
    while(i < maxit && loss > abstol ) {
        
        # iteration index
        i <- i +1  # why not just start at 1? then increment at the end? same difference tho I guess!
        
        # forward ....
        # 1 indicate row, 2 indicate col
        

        hidden.layer <- sweep(X %*% W1 , 2, b1, '+')
                # X is a 75row/4col matrix
                # W1 is a 4row/6col matrix (6, one for each node in the next layer which is the hidden layer)
                # the inner "X %*% W1" yields us a 75row/6col matrix from the matrix multiplication (that makes sense)
                # b1 is initialized as 1row, 6col full of zeros, so the sweep "+" operation isn't doing anything on round 1
                # on the first iteration, the sweep does nothing because b1 is full of zeros, see this below is all "TRUEs"
                sweep(X %*% W1, 2, b1, '+') == X %*% W1  # will only be "trues" for first iteration when b1 is all zeros
        
                # I think if you had multiple hidden layers, you'd just need to do this part twice? we'll see
                
            
                
        # neurons : ReLU -- this is doing that f(x) = max(0, x) to eliminate negative numbers I believe?
        hidden.layer <- pmax(hidden.layer, 0)
        score <- sweep(hidden.layer %*% W2, 2, b2, '+')
        
        
        # softmax
        score.exp <- exp(score)
                
                score[1,1]
                exp(score[1,1])
                score.exp[1,1]
                score.exp
        
        # debug
        probs <- score.exp/rowSums(score.exp)
        
                # is the exp function really necessary to get these to sum to one?
                probs2 <- score/rowSums(score)
        
                sum(probs[1,]); probs[1,]; score.exp[1,]
                sum(probs2[1,]); probs2[1,]; score[1,]
                        probs
                        probs2
        
        
        # compute the loss
        # this aligns the probability we currently have for each of the "correct" classes
        
        # this is really clever use of Matrix1[Matrix2] where Matrix2 is essentially a 
        # mapping between rownumber and column number of the "answer" classification
        corect.logprobs <- -log(probs[Y.index]) 
        
                probs    # These are our predicted class probs, which one to use??
                Y.index  # where these are the rownumber/column that correspond to which col to use above
        
        
                corect.logprobs
                # this is interesting...
                # this is the manual way to do the mapping he did above
                c(probs[1:25,1], probs[26:50,2], probs[51:75,3]) == probs[Y.index]
                # both probs and Y.index are matrices
                # "probs[Y.index]" is subsetting "probs" based on column indeces stored in Y.index
        
        # summing up all of the correct logprobs then dividing by this total batch size
        data.loss  <- sum(corect.logprobs)/batchsize  # this is essentially the average loss per obs in batch
        
        
        # square all weights, sum them, then sum sums, then multiply by (reg * 1/2)
        reg.loss   <- 0.5*reg* (sum(W1*W1) + sum(W2*W2))
        
        
        loss <- data.loss + reg.loss
        
        # display results and update model
        if( i %% display == 0) {
            if(!is.null(testdata)) {
                model <- list( D = D,
                               H = H,
                               K = K,
                               # weights and bias
                               W1 = W1, 
                               b1 = b1, 
                               W2 = W2, 
                               b2 = b2)
                labs <- predict.dnn(model, testdata[,-y])
                accuracy <- mean(as.integer(testdata[,y]) == Y.set[labs])
                cat(i, loss, accuracy, "\n")
            } else {
                cat(i, loss, "\n")
            }
        }
        
        # backward ....
        dscores <- probs
        dscores[Y.index] <- dscores[Y.index] -1
        dscores <- dscores / batchsize
        
        
        dW2 <- t(hidden.layer) %*% dscores 
        db2 <- colSums(dscores)
        
        dhidden <- dscores %*% t(W2)
        dhidden[hidden.layer <= 0] <- 0
        
        dW1 <- t(X) %*% dhidden
        db1 <- colSums(dhidden) 
        
        # update ....
        dW2 <- dW2 + reg*W2
        dW1 <- dW1  + reg*W1
        
        W1 <- W1 - lr * dW1
        b1 <- b1 - lr * db1
        
        W2 <- W2 - lr * dW2
        b2 <- b2 - lr * db2
        
        
        
    }
    
    # final results
    # creat list to store learned parameters
    # you can add more parameters for debug and visualization
    # such as residuals, fitted.values ...
    model <- list( D = D,
                   H = H,
                   K = K,
                   # weights and bias
                   W1= W1, 
                   b1= b1, 
                   W2= W2, 
                   b2= b2)
    
    return(model)
}

########################################################################
# testing
#######################################################################
set.seed(1)

# 0. EDA
summary(iris)
plot(iris)

# 1. split data into test/train
    
    # this appears to be some stratified sampling since 1:50 is a species type, 51-100 is another species, etc.
    # author wanted to sample 25 of each of the species types randomly
    
samp <- c(sample(1:50,25), sample(51:100,25), sample(101:150,25))

    class(samp)  # this is an integer vector of indexes I assume

# 2. train model

    # ah ok, I see. x and y are column index values, that would have taken me a while to figure out...

ir.model <- train.dnn(x=1:4, y=5, traindata=iris[samp,], testdata=iris[-samp,], hidden=10, maxit=2000, display=50)
# ir.model <- train.dnn(x=1:4, y=5, traindata=iris[samp,], hidden=6, maxit=2000, display=50)

    # ok well that was quick AF...  I like this a lot, this is going to help me learn how these things work
    # once and for all!

# 3. prediction
# NOTE: if the predict is factor, we need to transfer the number into class manually.
#       To make the code clear, I don't write this change into predict.dnn function.
labels.dnn <- predict.dnn(ir.model, iris[-samp, -5])

    # keep in mind, he wrote is own predict.dnn function which can be found at the top of this script.

# 4. verify the results
table(iris[-samp,5], labels.dnn)  # this thing killed it!
#          labels.dnn
#            1  2  3
#setosa     25  0  0
#versicolor  0 24  1
#virginica   0  0 25

#accuracy
mean(as.integer(iris[-samp, 5]) == labels.dnn)
# 0.98

# 5. compare with nnet
library(nnet)
ird <- data.frame(rbind(iris3[,,1], iris3[,,2], iris3[,,3]),
                  species = factor(c(rep("s",50), rep("c", 50), rep("v", 50))))
ir.nn2 <- nnet(species ~ ., data = ird, subset = samp, size = 6, rang = 0.1,
               decay = 1e-2, maxit = 2000)


labels.nnet <- predict(ir.nn2, ird[-samp,], type="class")
table(ird$species[-samp], labels.nnet)
#  labels.nnet
#   c  s  v
#c 22  0  3
#s  0 25  0
#v  3  0 22

# accuracy
mean(ird$species[-samp] == labels.nnet)
# 0.96


# Visualization
# the output from screen, copy and paste here.
data1 <- ("i loss accuracy
          50 1.098421 0.3333333 
          100 1.098021 0.3333333 
          150 1.096843 0.3333333 
          200 1.093393 0.3333333 
          250 1.084069 0.3333333 
          300 1.063278 0.3333333 
          350 1.027273 0.3333333 
          400 0.9707605 0.64 
          450 0.8996356 0.6666667 
          500 0.8335469 0.6666667 
          550 0.7662386 0.6666667 
          600 0.6914156 0.6666667 
          650 0.6195753 0.68 
          700 0.5620381 0.68 
          750 0.5184008 0.7333333 
          800 0.4844815 0.84 
          850 0.4568258 0.8933333 
          900 0.4331083 0.92 
          950 0.4118948 0.9333333 
          1000 0.392368 0.96 
          1050 0.3740457 0.96 
          1100 0.3566594 0.96 
          1150 0.3400993 0.9866667 
          1200 0.3243276 0.9866667 
          1250 0.3093422 0.9866667 
          1300 0.2951787 0.9866667 
          1350 0.2818472 0.9866667 
          1400 0.2693641 0.9866667 
          1450 0.2577245 0.9866667 
          1500 0.2469068 0.9866667 
          1550 0.2368819 0.9866667 
          1600 0.2276124 0.9866667 
          1650 0.2190535 0.9866667 
          1700 0.2111565 0.9866667 
          1750 0.2038719 0.9866667 
          1800 0.1971507 0.9866667 
          1850 0.1909452 0.9866667 
          1900 0.1852105 0.9866667 
          1950 0.1799045 0.9866667 
          2000 0.1749881 0.9866667  ")

data.v <- read.table(text=data1, header=T)
par(mar=c(5.1, 4.1, 4.1, 4.1))
plot(x=data.v$i, y=data.v$loss, type="o", col="blue", pch=16, 
     main="IRIS loss and accuracy by 2-layers DNN",
     ylim=c(0, 1.2),
     xlab="",
     ylab="",
     axe =F)
lines(x=data.v$i, y=data.v$accuracy, type="o", col="red", pch=1)
box()
axis(1, at=seq(0,2000,by=200))
axis(4, at=seq(0,1.0,by=0.1))
axis(2, at=seq(0,1.2,by=0.1))
mtext("training step", 1, line=3)
mtext("loss of training set", 2, line=2.5)
mtext("accuracy of testing set", 4, line=2)

legend("bottomleft", 
       legend = c("loss", "accuracy"),
       pch = c(16,1),
       col = c("blue","red"),
       lwd=c(1,1)
)
