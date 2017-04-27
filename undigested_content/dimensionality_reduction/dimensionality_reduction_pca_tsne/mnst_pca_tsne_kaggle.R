

# This Kaggle post does a good comparison of PCA / t-SNE using the MNST (digit recognition) dataset
# https://www.kaggle.com/puyokw/digit-recognizer/clustering-in-2-dimension-using-tsne/code 

# here is the raw code modified to work locally (had to edit file paths)

            # modification for working dir:
            library(rstudioapi)
            setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
            datapath <- "LARGE_FILES_tsne_mnst/"
            list.files(datapath)
    
    
    # resume
    library(readr)
    library(Rtsne)
    # The competition datafiles are in the directory ../input
    # Read competition data files:
    #train <- read_csv("../input/train.csv")
    #test <- read_csv("../input/test.csv")
    
            
            # modification for reading in different file paths (suspect we only need train)
            train_og <- read_csv(paste0(datapath, "train.csv"))
            train <- train_og  # I want to be able to retain what the original train file looked like
            head(train)
            
            
    train$label <- as.factor(train$label)
    
    # shrinking the size for the time limit
    numTrain <- 10000
    set.seed(1)
    rows <- sample(1:nrow(train), numTrain)
    train <- train[rows,]
    # using tsne
    set.seed(1) # for reproducibility
    tsne <- Rtsne(train[,-1], dims = 2, perplexity=30, verbose=TRUE, max_iter = 500)   # 11:27 - 11:28 
    # visualizing
    colors = rainbow(length(unique(train$label)))
    names(colors) = unique(train$label)
    plot(tsne$Y, t='n', main="tsne")
    text(tsne$Y, labels=train$label, col=colors[train$label])
    
    # compare with pca
    pca = princomp(train[,-1])$scores[,1:2]
    plot(pca, t='n', main="pca")
    text(pca, labels=train$label,col=colors[train$label])
    
    

