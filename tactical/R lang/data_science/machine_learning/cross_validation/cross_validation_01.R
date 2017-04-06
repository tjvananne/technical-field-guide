

#' cross validation with unstratified splitting (not looking at the target value to split evenly)

    # creating folds function:
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

        
    # testing:
    
    my_iris <- iris[1:149,]
        
    set.seed(1776)
    myfolds <- create_folds(my_iris, 3, sorted = T)
    
    myfolds[[1]]
    sort(myfolds[[1]]); length(myfolds[[1]])
    sort(myfolds[[2]]); length(myfolds[[2]])
    sort(myfolds[[3]]); length(myfolds[[3]])
    
    
    sum(!myfolds[[1]] %in% myfolds[[2]]) == length(myfolds[[1]])
    sum(!myfolds[[1]] %in% myfolds[[3]]) == length(myfolds[[1]])
    sum(!myfolds[[2]] %in% myfolds[[3]]) == length(myfolds[[2]])

    
    # implement cv for a linear model -- predicting Sepal.Length
    
        # quick RMSE function def:
        RMSE <- function(predictions, actuals) {
            return(sqrt(mean((predictions - actuals)^2)))
        }
    
    
        my_iris <- iris[1:149,]
        
        # split a holdout -- remove those from training data
        set.seed(1776)
        holdout_indx <- sample(nrow(my_iris), 31)
        holdout <- my_iris[holdout_indx,]
        train <- my_iris[-holdout_indx,]
        
        
        # build folds with train
        set.seed(1776)
        k <- 3
        myfolds <- create_folds(train, k, sorted = T)
        sapply(myfolds, length)  # spot check
        
        
        
        #' this will eventually be wrapped in a function
        #' we pass in:
        #'     y_label (string)
        #'     scoring_metric (function) -- or maybe string and we generate the function?
        #'     fold index
        
        
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
            return_list[[1]] <- fold_metrics
            
            if(!is.null(holdout)) {
                
                # train on all data
                train_lm <- eval(parse(text = paste0("lm(", y_label, " ~ ., data = data)")))
                
                # separate out user-provided holdout set
                holdout_y <- holdout[y_label]
                holdout[y_label] <- NULL
                
                
                holdout_preds <- predict(train_lm, holdout) 
                holdout_metric <- scoring_metric(holdout_preds, holdout_y)
                print(holdout_metric)
                
                return_list[[2]] <- holdout_metric
                names(return_list) <- c("fold_metrics", "holdout_metric")
                return(return_list)
                
            } else {
                return(fold_metrics)
            }
        }
        
        
        # call the function
        conduct_cv(data = train, y_label = 'Sepal.Length', scoring_metric = RMSE, index_folds = myfolds, holdout = holdout)
        
        
        
    # # PROCEDURALLY, IT WORKS!
    #     
    #     y_label <- 'Sepal.Length'
    #     scoring_metric <- RMSE
    #     
    #     fold_metrics <- numeric(k)
    #     
    #     # this is the actual cross val
    #     for(i in 1:k) {
    #         
    #         
    #         this_train <- train[ -myfolds[[i]], ]
    #         this_train_y <- this_train[y_label]
    #         
    #         this_test <- train[ myfolds[[i]], ]
    #         this_test_y <- this_test[y_label]
    #         this_test[y_label] <- NULL    
    #         
    #         this_lm <- eval(parse(text = paste0("lm(", y_label, " ~ ., data = this_train)")))
    #         
    #         this_preds <- predict(this_lm, this_test)
    #         
    #         fold_metrics[[i]] <- scoring_metric(this_preds, this_test_y)
    #             
    #     }    
    #     
    #     # spot check
    #     fold_metrics
    #     cv_best <- min(fold_metrics); cv_best
    #     cv_mean <- mean(fold_metrics); cv_mean
    #     cv_median <- median(fold_metrics); cv_median
    #     
    #     
    #     # this is the same model applied to all of train, then tested on the holdout
    #     train_lm <- eval(parse(text = paste0("lm(", y_label, " ~ ., data = train)")))
    #     
    #     holdout_y <- holdout[y_label]
    #     holdout[y_label] <- NULL
    #     
    #     holdout_preds <- predict(train_lm, holdout) 
    #     holdout_metric <- scoring_metric(holdout_preds, holdout_y)
    #     holdout_metric    
    # 
    # 
    
