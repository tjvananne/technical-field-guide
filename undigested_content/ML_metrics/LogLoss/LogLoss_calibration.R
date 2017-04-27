

# log loss minimization:
# https://www.analyticsvidhya.com/blog/2016/07/platt-scaling-isotonic-regression-minimize-logloss-error/
# https://www.drivendata.org/competitions/2/warm-up-predict-blood-donations/page/7/


# log loss definition:

    LogLoss <- function(act, pred) {
        eps = 1e-15;
        nr = length(pred)
        pred = matrix(sapply( pred, function(x) max(eps,x)), nrow = nr) 
        pred = matrix(sapply( pred, function(x) min(1-eps,x)), nrow = nr)
        ll = sum(act*log(pred) + (1-act)*log(1-pred))
        ll = ll * -1/(length(act)) 
        return(ll);
    }


    
# looking at calibration techniques for log loss:
    plot(c(0,1),c(0,1), col="grey",type="l",xlab = "Mean Prediction",ylab="Observed Fraction")
    reliability.plot <- function(obs, pred, bins=10, scale=T) {
        # Plots a reliability chart and histogram of a set of predicitons from a classifier
        #
        # Args:
        # obs: Vector of true labels. Should be binary (0 or 1)
        # pred: Vector of predictions of each observation from the classifier. Should be real
        # number
        # bins: The number of bins to use in the reliability plot
        # scale: Scale the pred to be between 0 and 1 before creating reliability plot
        require(plyr)
        library(Hmisc)
        min.pred <- min(pred)
        max.pred <- max(pred)
        min.max.diff <- max.pred - min.pred
        if (scale) {
            pred <- (pred - min.pred) / min.max.diff 
        }
        bin.pred <- cut(pred, bins)
        k <- ldply(levels(bin.pred), function(x) {
            idx <- x == bin.pred
            c(sum(obs[idx]) / length(obs[idx]), mean(pred[idx]))
        })
        is.nan.idx <- !is.nan(k$V2)
        k <- k[is.nan.idx,]
        return(k)
    }
    

        
library(rstudioapi)
library(caret)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))   
list.files()    

    # following along while typing along --

        # there is no train and test, but I'll just read it in for now
        blood_data <- read.csv("LARGE_FILES_logloss_blood_donation/blood_donation_data.csv")  # "*LARGE_FILES*" for gitignore
        head(blood_data)
        
        blood_data$donated_blood <- as.factor(blood_data$donated_blood)
        head(blood_data)    
        
        
        # he had train and test datasets, I don't so I'll manually whip those up real quick
        set.seed(1)
        train_indx <- caret::createDataPartition(y=blood_data$donated_blood, times=1, p=0.7, list=F)
        train <- blood_data[train_indx,]
        test <- blood_data[-train_indx,]
        
        
          
        # he removed columns, but I don't think I even have those columns?
        
        
        
        set.seed(221)
        # I prefer stratified split on the target var, but whatever, we'll keep it rando
        sub <- sample(nrow(train), floor(nrow(train) * 0.85))
        training <- train[sub,]
        cv <- train[-sub,]
        
            
        
        # train a rf without any feature gen or pre proc
        library(randomForest)
        model_rf <- randomForest(donated_blood ~., data=training, keep.forest=T, importance=T)
        print(model_rf)
        
        # predicting on the cross val dataset
        result_cv <- as.data.frame(predict(model_rf, cv, type="prob"))
        
        
        # calculating Log Loss without Platt Scaling
        LogLoss(as.numeric(as.character(cv$donated_blood)), result_cv$`1`)
        
        # performing platt scaling on the dataset
        dataframe <- data.frame(result_cv$`1`, cv$donated_blood)
        colnames(dataframe) <- c("x", "y")
        
        
        # training a logistic regression model on the cross val dataset
        model_log <- glm(y~x, data=dataframe, family=binomial)
        
        
        #predicting on the cross validation after platt scaling
        result_cv_platt <- predict(model_log, dataframe[-2], type="response")
        LogLoss(as.numeric(as.character(cv$donated_blood)), result_cv_platt)
        
        
        # plotting reliability plots
        # the line below computes the reliability plot data for cross validation dataset without platt scaling
        k <- reliability.plot(as.numeric(as.character(cv$donated_blood)), result_cv$`1`, bins = 5)
        lines(k$V2, k$V1, xlim=c(0, 1), ylim=c(0, 1), xlab="Mean Prediction", ylab="Observed Fraction",
              col="blue", type='o', main="Reliability Plot")




# redo except going to copy pasta

        list.files()
        
        
        # reading the train dataset
        train <-read.csv("blood_donation_data.csv")
        
        names(train)
        train$monetary_cc_blood <- NULL
        head(train)
        
        # reading the test dataset
        #test <-read.csv("test.csv")  # i have no test data?
        
        
        #converting the dependent variable into factor for classification purpose.
        train$donated_blood<-as.factor(train$donated_blood)   
        
        # removing the X column since it is irrelevant for our training and total colume column since it is perfectly correlated to number of donations
        #train<-train[-c(1,4)]  # did this manually
        
        # splitting the train set into training and cross validation set using random sampling
        set.seed(221)
        sub <- sample(nrow(train), floor(nrow(train) * 0.85))
        training<-train[sub,]
        cv<-train[-sub,]
        
        # training a random forest model without any feature engineering or pre-processing
        library(randomForest)
        model_rf<-randomForest(donated_blood~.,data = training,keep.forest=TRUE,importance=TRUE)
        
        #predicting on the cross validation dataset
        result_cv<-as.data.frame(predict(model_rf,cv,type="prob"))   
        
        #calculating Log Loss without Platt Scaling
        LogLoss(as.numeric(as.character(cv$donated_blood)),result_cv$`1`)   
        
        # performing platt scaling on the dataset
        dataframe<-data.frame(result_cv$`1`,cv$donated_blood)
        colnames(dataframe)<-c("x","y")
       
    ############################################################################################################## 
    # un-indenting this because this is it... this is what platt scaling is, just a glm to glue classifier output to label
    # training a logistic regression model on the cross validation dataset
    model_log<-glm(y~x,data = dataframe,family = binomial)
    
    #predicting on the cross validation after platt scaling
    result_cv_platt<-predict(model_log,dataframe[-2],type = "response")
    result_cv$result_cv_platt <- result_cv_platt
    LogLoss(as.numeric(as.character(cv$donated_blood)),result_cv_platt)
    #############################################################################################################   
     
        # plotting reliability plots
        
        # The line below computes the reliability plot data for cross validation dataset without platt scaling
        k <-reliability.plot(as.numeric(as.character(cv$donated_blood)),result_cv$`1`,bins = 5)
        lines(k$V2, k$V1, xlim=c(0,1), ylim=c(0,1), xlab="Mean Prediction", ylab="Observed Fraction", col="red", type="o", main="Reliability Plot")
        
        #This line below computes the reliability plot data for cross validation dataset with platt scaling
        k <-reliability.plot(as.numeric(as.character(cv$donated_blood)),result_cv_platt,bins = 5)
        lines(k$V2, k$V1, xlim=c(0,1), ylim=c(0,1), xlab="Mean Prediction", ylab="Observed Fraction", col="blue", type="o", main="Reliability Plot")
        
        legend("topright",lty=c(1,1),lwd=c(2.5,2.5),col=c("blue","red"),legend = c("platt scaling","without plat scaling"))
        
        
        summary(result_cv$`1`)
        summary(result_cv$result_cv_platt)        
