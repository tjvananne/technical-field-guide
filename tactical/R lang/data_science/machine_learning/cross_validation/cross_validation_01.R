

# for understanding what cross val is, why to do it, and the types:
# https://www.youtube.com/watch?v=e0JcXMzhtdY


    #' think critically about what cross validation is, don't just accept it as a common thing data scientists and machine
    #' learning engineers do when training models. Put yourself in the shoes of the person who discovered or invented the 
    #' concept. The problem was interesting. 
    #' 
    #' First, there was this idea of using data to train a model and then use that 
    #' model to predict on new, unseen data. Cool, that works.
    #' 
    #' Next, someone came up with the idea to split their train set into two pieces, train the model on one piece, and 
    #' see how effective the model would have been if we pretend like that second piece of the training set was "unseen" 
    #' and we didn't know the answers.
    #' 
    #' But! someone probably later discovered that... sometimes the model will fit significantly better to this 
    #' "test" set (the second piece of training data set aside for testing) than it does to future unseen data. It is
    #' almost as if the model has "overfit" to this "test" set and is no longer generalizing to the patterns of the
    #' data as a whole, but is picking out distinct instances of unique sets of cases in the "test" set and weighting
    #' that information too heavily.
    #' 
    #' Hmm... well where do we go from here? Someone else came along and said, well let's split that thing (training data)
    #'  up into several different pieces (say, 5) and see if we can "take turns" training a model on 4 pieces of that data
    #'  and using the remaining piece as the test. If we optimize our model to the average of these iterations, then there
    #'  is much less of a chance for the data to "overfit" to particular examples and we will get a much more accurate 
    #'  idea of how effective our model is as a whole.
    #'  
    #'  That is a beautiful thought process. (unless that isn't at all how it went... in which case, whatever. I choose to believe)



# function to create folds ------------------------------------------------------------------------------------

        create_folds <- function(dataset, k_folds, sorted = F) {
            
            nrdf <- nrow(dataset) 
            potential_index <- 1:nrdf
            unused_index <- 1:nrdf
            folds <- vector("list", k_folds)
            obs_per_fold <- floor(nrdf / k_folds)
            
            # build folds iteratively
            for(i in 1:k_folds) {
                folds[[i]] <- sample(potential_index[potential_index %in% unused_index], obs_per_fold)
                unused_index <- unused_index[!unused_index %in% folds[[i]]]
                
                if(sorted) {folds[[i]] <- sort(folds[[i]])}
                
                # handle the remainder if number of observations doesn't go into k_folds evenly
                if(i == k_folds & length(unused_index > 0)) {
                    
                    # redistribute the remainder across folds evenly
                    for(j in 1:length(unused_index)) {
                        folds[[j]] <- c(folds[[j]], unused_index[[j]])
                    }
                }
            }
            return(folds)   
        }

       
         
                    # # testing this function:
                    # my_iris <- iris[1:149,]
                    # set.seed(1776)
                    # myfolds <- create_folds(my_iris, 3, sorted = T)
    
    
                    # # just for prints
                    # myfolds[[1]]
                    # sort(myfolds[[1]]); length(myfolds[[1]])
                    # sort(myfolds[[2]]); length(myfolds[[2]])
                    # sort(myfolds[[3]]); length(myfolds[[3]])
                    # 
                    # 
                    # sum(!myfolds[[1]] %in% myfolds[[2]]) == length(myfolds[[1]])
                    # sum(!myfolds[[1]] %in% myfolds[[3]]) == length(myfolds[[1]])
                    # sum(!myfolds[[2]] %in% myfolds[[3]]) == length(myfolds[[2]])

    
    
        
        
# RMSE ---------------------------------------------------------------------------------------------
        # this is our measurement for how effective our model is, the lower the better
                    
                    
        # quick RMSE function def:
        RMSE <- function(predictions, actuals) {
            return(sqrt(mean((predictions - actuals)^2)))
        }
    
    
        
        
# this is the implementation of cross validation -------------------------------------------------------------------
        
        
        # holdout is an optionally provided dataset
        conduct_cv <- function(data, y_label, scoring_metric, index_folds, holdout=NULL) {
            
            
            # set up function variables
            k <- length(index_folds)
            fold_metrics <- numeric(k)   
            return_list <- list()
            
            
            # this is the actual cross val
            for(i in 1:k) {
                
                print(paste0("on fold: ", i))
                
                # set train
                this_train <- data[ -index_folds[[i]], ]
                this_train_y <- this_train[y_label]
                
                # set test
                this_test <- data[ index_folds[[i]], ]
                this_test_y <- this_test[y_label]
                this_test[y_label] <- NULL    
                
                # model
                this_lm <- eval(parse(text = paste0("lm(", y_label, " ~ ., data = this_train)")))
                
                # predict
                this_preds <- predict(this_lm, this_test)
                
                # store results
                fold_metrics[[i]] <- scoring_metric(this_preds, this_test_y)
                
            }    
            
            print("Done with cv, results:")
            print(fold_metrics)
            print(paste0("mean of CVs: ", mean(fold_metrics)))
            return_list[[1]] <- fold_metrics
            
            if(!is.null(holdout)) {
                
                # train on all data
                train_lm <- eval(parse(text = paste0("lm(", y_label, " ~ ., data = data)")))
                
                # separate out user-provided holdout set
                holdout_y <- holdout[y_label]
                holdout[y_label] <- NULL
                
                
                holdout_preds <- predict(train_lm, holdout) 
                holdout_metric <- scoring_metric(holdout_preds, holdout_y)
                print(paste0("Holdout results: ", holdout_metric))
                
                return_list[[2]] <- holdout_metric
                names(return_list) <- c("fold_metrics", "holdout_metric")
                return(return_list)
                
            } else {
                return(fold_metrics)
            }
        }
        
        
        

                # test this function
                my_iris <- iris[1:149,]
                set.seed(1776)
                holdout_indx <- sample(nrow(my_iris), 31)
                holdout <- my_iris[holdout_indx,]
                train <- my_iris[-holdout_indx,]
                
                
                # build folds with train
                k <- 3
                myfolds <- create_folds(train, k, sorted = T)
                sapply(myfolds, length)  # spot check
                
                myfolds <- create_folds(train, 3, sorted = T)
                conduct_cv(data = train, y_label = 'Sepal.Length', scoring_metric = RMSE, index_folds = myfolds, holdout = holdout)
            
        
        