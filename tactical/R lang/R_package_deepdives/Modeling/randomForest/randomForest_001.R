

# random forest documentation: RTFM
# https://cran.r-project.org/web/packages/randomForest/randomForest.pdf (4.6-12 October 7, 2015)

library(randomForest)




# classCenter

    rm(list = ls())

    data(iris)
    iris.rf <- randomForest(iris[,-5], iris[,5], prox = TRUE)
    
        # iris[,-5]  # all of the data except the 5th column
        # iris[,5]   # all of the data IN the 5th column
    
    iris.p <- classCenter(iris[, -5], iris[, 5], iris.rf$prox)
    
        # first arg is the data without the class label
        # second arg is the class label
        # third arg is proximity matrix (iris.rf$prox)  
        # last arg is number of nearest neightbors used to find protos
            # defaults to the length of whichever class label has fewest obs (minus 1)
        

    plot(iris[, 3], iris[, 4], pch = 21, xlab = names(iris)[3], ylab=names(iris)[4],
         bg=c("red", "blue", "green")[as.numeric(factor(iris$Species))],
         main="Iris Data with Prototypes")
    
    # adding the prototype points from iris.p
    points(iris.p[,3], iris.p[,4], pch=21, cex=3, bg=c("red", "blue", "green"))
    
    
  
    
    
    
    
    
    
      
# combine - Combine two or more ensembles of trees into one
    
        #' "norm.votes" parameter:
        #' If TRUE (default), the final result of votes are expressed as fractions. 
        #' If FALSE, raw vote counts are returned (useful for combining results 
        #' from different runs). Ignored for regression
    
    # i assume this is a bagging function
    rf1 <- randomForest(Species ~., iris, ntree=50, norm.votes=FALSE)
    rf2 <- randomForest(Species ~., iris, ntree=50, norm.votes=FALSE)  
    rf3 <- randomForest(Species ~., iris, ntree=50, norm.votes=FALSE)    
    rf.all <- combine(rf1, rf2, rf3)    
    print(rf.all)    
    
    
    #' so I guess this would be good for ensembling classifiers. Note
    #' that it apparently won't work out too well for regressions.
    #' 
    #' I'm also guessing that variables used to train all have to 
    #' be same or similar?
    #' 
    #' Also: The confusion, err.rate, mse and rsq components (as well 
    #' as the corresponding components in the test compnent, if 
    #' exist) of the combined object will be NULL.
    
    
    
    
    
    
    
    
    
# getTree - extract a single tree from a forest
# plotting: https://stats.stackexchange.com/questions/41443/how-to-actually-plot-a-sample-tree-from-randomforestgettree
    
    rm(list=ls())
    library(ggplot2)
    
            # for plotting individual trees
            # library(devtools)
            # install_github('araastat/reprtree')
            library(reprtree)
    
            # # well this is just a bonus, wasn't needed at all lol
            # # Three different syntaxes to get to long format with iris
            # library(tidyr)
            # iris.long <- tidyr::gather(iris, key = flower_att, value = measurement, 
            #                            -Species)
            # iris.long2 <- tidyr::gather(iris, key = flower_att, value = measurement, 
            #                             Sepal.Length:Petal.Width)
            # iris.long3 <- tidyr::gather(iris, key = flower_att, value = measurement,
            #                             Sepal.Length, Sepal.Width, Petal.Length, Petal.Width)
    
    
    
    # set seed for deterministic result
    set.seed(1776)
    # myrf <- randomForest(iris[,-5], iris[,5], ntree=1)  # can be called in x, y format   
    myrf <- randomForest(Species ~., data=iris, ntree=1)  # can also be called with a formula
    
    
    # allows you to see the variable choices and split points in data.frame format
    tree1 <- getTree(myrf, 1, labelVar=TRUE)    
    # View(tree1)
    # the node is terminal if daughter nodes are zero (will also have prediction)
    
    
    # plot the tree (THIS ONLY WORKS IF MODEL WAS CREATED FROM FORMULA)
    reprtree:::plot.getTree(myrf)
    
    
        #' It makes sense that the model would choose this as a split point, it can be
        #' fairly confident that any flower with a Petal.Width less than 0.75 
        
        # ggplot the Petal.Width (this will be first split point for terminal node later on)
        ggplot(data = iris, aes(x = Petal.Width, fill = Species)) +
            geom_density(alpha = 0.3) +
            ggtitle("When Petal.Width is < 0.75; The model Classifies as setosa") +
            geom_vline(xintercept = 0.75, color = 'red', size=2)
        
        ggplot(data = iris, aes(x = Petal.Width, fill = Species)) +
            geom_histogram(alpha = 0.3, position='identity') +
            ggtitle("When Petal.Width is < 0.75; The model Classifies as setosa") +
            geom_vline(xintercept = 0.75, color = 'red', size=2)
    
        # ok so that looks like a pretty solid split point, but we are basing this off of
        # only a single tree. I bet we can do better if we actually use a whole forest.
    
    
    # tree plotting also works for the end result / bagged tree 
    model <- randomForest(Species ~ ., data=iris, importance=TRUE, 
                          ntree=500, mtry = 2, do.trace=100)
    reprtree:::plot.getTree(model)

    importance(model)
    
    #' this larger, more robust model chose Petal.Length < 2.45 as a split point 
    #' instead, lets check that one out. 
    
        ggplot(data = iris, aes(x = Petal.Length, fill = Species)) +
            geom_density(alpha = 0.3) +
            ggtitle("Split 1: When Petal.Length is < 2.45, we classify as setosa") +
            geom_vline(xintercept = 2.45, color = 'red', size=2)
        
        ggplot(data = iris, aes(x = Petal.Length, fill = Species)) +
            geom_histogram(alpha = 0.3, position = "identity") +
            ggtitle("Split 1: When Petal.Length is < 2.45, we classify as setosa") +
            geom_vline(xintercept = 2.45, color = 'red', size=2)
    
        #' Yep, it looks like this was a better decision
        #' than what our single-tree-forest from before made. That makes sense! The more
        #' trees we have "voting" in our forest, the better odds of our forest being accurate






# grow - Add trees to an ensemble
    
    # add additional trees to an existing ensemble of trees
    
    data(iris)
    iris.rf <- randomForest(Species ~., iris, ntree=50, norm.votes=FALSE)
    iris.rf.grown <- grow(iris.rf, 50)
    
        # we're losing something:
        setdiff( names(iris.rf), names(iris.rf.grown) )
        # we lose "err.rate" and "confusion" whenever we grow the ensemble
        
    iris.rf$confusion  # this is beautiful - we'll look at these all later
    
    print(iris.rf)
        
    
    
    
    
    
    
# importance - Extract variable importance measure
    
    # interpreting results:
    # https://stats.stackexchange.com/questions/164569/interpreting-output-of-importance-of-a-random-forest-object-in-r
    # need to revisit what ISLR says about r forests before interpreting that
    
    set.seed(4543)
    data(mtcars)
    mtcars.rf <- randomForest(mpg ~., data=mtcars, ntree=1000,
                              keep.forest=FALSE, importance=TRUE)
    importance(mtcars.rf)    
    importance(mtcars.rf, type=1)    
        
    
    
    
    
# margin - compute or plot the margin of predictions from rf classifier
    
    #' The margin of a data point is defined as the proportion of votes for 
    #' the correct class minus maximum proportion of votes for the other 
    #' classes. Thus under majority votes, positive margin means correct 
    #' classification, and vice versa.
    
    library(randomForest)
    
    ?randomForest
    ?margin
    
    set.seed(1)
    data(iris)
    iris.rf <- randomForest(Species ~., iris, keep.forest=T, ntree=20)
    plot(margin(iris.rf))  
    
    set.seed(1)
    iris.rf2 <- randomForest(Species ~., iris[sample(1:150, 30),],
                             keep.forest=T, ntree=20)
    plot(margin(iris.rf2))
    
    # anything over 0 represents a "positive/correct" classification
    # I guess you can only calculate / plot this for train data?
    
    print(iris.rf)
    
    
    
    
    
# MDSplot - Multi-dimensional scaling plot of proximity matrix
    
    rm(list=ls())
    library(randomForest)
    
    set.seed(1)
    data(iris)
    iris.rf <- randomForest(Species ~., iris, proximity=T, keep.forest=F)
    MDSplot(iris.rf, iris$Species)
    
    #' This looks like some form of dimensionality reduction like
    #' a PCA or t-SNE type plot?
    
    
    
    
# na.roughfix - rough imputation ofmissing vlaues
    
    # not going to display this one, self explanatory
    
    
    
    
    
    
# outlier - compute outlying measures
    
    #' A numeric vector containing the outlying measures. The outlying 
    #' measure of a case is computed as sum(squared proximity), 
    #' normalized by subtracting the median and divided by the 
    #' MAD, within each class.
    
    rm(list = ls())
    library(randomForest)
    
    set.seed(1)
    iris.rf <- randomForest(Species ~., data=iris, proximity=T)
    
    
    plot(outlier(iris.rf), type="h",
         col=c("red", "green", "blue")[as.numeric(iris$Species)])

    outlier_df <- outlier(iris.rf)
    
    
    
    
    
# partialPlot - partial dependence plot
    
    rm(list=ls())
    library(randomForest)

    #' So this one I'll need to come back to, there is a lot 
    #' of mathematical notation here and this seems to be a 
    #' very complex calculation
        
    
    # for now, here is a runthrough
    data(iris)
    set.seed(543)
    iris.rf <- randomForest(Species~., iris)
    partialPlot(iris.rf, iris, Petal.Width, "versicolor")
    
    
    ## Looping over variables ranked by importance:
    data(airquality)
    airquality <- na.omit(airquality)
    set.seed(131)
    ozone.rf <- randomForest(Ozone ~ ., airquality, importance=TRUE)
    imp <- importance(ozone.rf)
    impvar <- rownames(imp)[order(imp[, 1], decreasing=TRUE)]
    
    op <- par(mfrow=c(2, 3))
    for (i in seq_along(impvar)) {
        partialPlot(ozone.rf, airquality, impvar[i], xlab=impvar[i],
                    main=paste("Partial Dependence on", impvar[i]),
                    ylim=c(30, 70))
    }
    par(op)
    
    
    # requires dev tools, but interesting to compare to output of partialPlots
    library(reprtree)
    reprtree:::plot.getTree(ozone.rf) 
    
    
    
    
    
# plot.randomForest - here we go, big time stuff
    
    rm(list=ls())
    library(randomForest)
    
    set.seed(1776)
    data(mtcars)
    plot(randomForest(mpg ~ ., mtcars, keep.forest=FALSE, ntree=100), log="y")
    
    
    
    
    
# predict.randomForest - come back to this one'
    
    # going to come back to this

    
    
    
    
# almost done, only about 5 more functions left
    
    
    
    