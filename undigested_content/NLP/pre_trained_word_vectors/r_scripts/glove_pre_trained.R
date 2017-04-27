

# using a glove pretrained word vector 

# set working dir and read in file
    library(rstudioapi)
    setwd(dirname(dirname(rstudioapi::getActiveDocumentContext()$path)))
    
    list.dirs()
    list.files("pre_trained")
    
    g6b <- scan(file = "LARGE_FILES_pre_trained/glove.6B.50d.txt", what="", sep="\n")
    
        class(g6b)  # character vector 
        g6b[58]  # this is a single quote, that's not going to work for us

    
    # reset button for testing new stuff
    rm( list= setdiff(ls(), 'g6b') )
    
    
# function defs for processing a pre-trained glove vector (from .txt format)
    
    # input .txt file, exports list of list of values and character vector of names (words)
    proc_pretrained_vec <- function(p_vec) {
        
        vals <- vector(mode = "list", length(p_vec))
        names <- character(length(p_vec))
        
        for(i in 1:length(p_vec)) {
            if(i %% 1000 == 0) {print(i)}
            this_vec <- p_vec[i]
            this_vec_unlisted <- unlist(strsplit(this_vec, " "))
            this_vec_values <- as.numeric(this_vec_unlisted[-1])  # this needs testing, does it become numeric?
            this_vec_name <- this_vec_unlisted[1]
            
            vals[[i]] <- this_vec_values
            names[[i]] <- this_vec_name
        }
    
        glove <- data.frame(vals)
        names(glove) <- names
        
        return(glove)
        
    }
    
    
   
# processing the raw pre-trained word vector:

    t_proc <- Sys.time()
    glove <- proc_pretrained_vec(g6b) 
    t_elap_proc <- Sys.time() - t_proc; print(t_elap_proc)
    
    
        # testing (pass)
        class(glove$the)
        glove$the
        names(glove)
    
        
    saveRDS(glove, file="LARGE_FILES_pre_trained/glove_6B_50D_processed.rds")
    

# exploring how to use the pre-trained word vector:
    # install.packages('text2vec')
    library(text2vec)
    

        
    class(glove[['paris']])
    glove[['paris']]
    
    
    
    # lets try to intuitively "calculate" what we think the vector should be for berlin using other relative vectors
    berlin <- glove[['paris']] - glove[['france']] + glove[['germany']]
    
    berlin              # this is our representation of what we think berlin should look like as a vector
    glove[['berlin']]   # this is the actual representation of what berlin looks like
    
    
        #' take-away: if we take paris (capital of france) and subtract france, then add germany, then we
        #' semantically should arrive at a similar representation of berlin (capital of germany)
        #' 
        #' Analogous: "Paris is as to France, as X is to Germany" -- can we programmatically solve for for X
        #' by simply reading in millions of sentences on the internet and machine learning their order? 
    
    
    
    # so now for our distance calculations, we need these to be in a matrix format
    berlin_mat <- matrix(berlin, nrow =length(berlin), ncol=1)
    glove_mat <- as.matrix(glove, nrow=nrow(glove), ncol=ncol(glove))
    
    
    glove_mat[,1] == glove[,1]  # these should all be true, no values should change just from switching to a matrix
    
        # so lets take a peak at the dimensions of our matrices we just created
        dim(berlin_mat)  # 50 rows by 1 column
        dim(glove_mat)   # 50 rows by 400,000 columns
    
    
    # the sim2() function from text2vec package in R prefers to work on columns, so let's transpose these so that number of columns matches    
    
    # I'll use the "t_" prefix to keep us organized
    t_berlin_mat <- t(berlin_mat)
    t_glove_mat <- t(glove_mat)
    
        # now check our dimensions again to make sure
        dim(t_berlin_mat)  # 1 row by 50 columns
        dim(t_glove_mat)   # 400,000 rows by 50 columns
    
    
    # compare our calculated vector (t_berlin_mat) with all the vectors in our glove_word_vector object to see which is most similar
    cos_sim = sim2(x=glove_mat, y=berlin_mat, method="cosine", norm="l2")      # NOTE: this fails, nrows are equal, but this is a col-based function
    cos_sim = sim2(x=t_glove_mat, y=t_berlin_mat, method="cosine", norm="l2")
    
    
    # sort so the most similar vectors are at the top
    sorted_cos_sim <- sort(cos_sim[,1], decreasing = T)  # sort the result 
    head(sorted_cos_sim)
    
    # berlin, frankfurt, munich, vienna are most similar. All are major cities in Germany! Awesome!

    
    
    

# OK LET'S T-SNE THIS!! Tag it for really common things like body-parts, emotions, maybe cities
# t-SNE with these categories! http://www.enchantedlearning.com/wordlist/body.shtml
    
    library(Rtsne)
    library(plyr)
    library(dplyr)
    
    
    glove <- readRDS(file="LARGE_FILES_pre_trained/glove_6B_50D_processed.rds")
    
    t_glove <- as.data.frame(t(glove))
    head(t_glove)
    
        # read in all of the category files
        tsne_cats <- list.files("LARGE_FILES_pre_trained/categories_for_tsne")
        tsne_cats_file <- list.files("LARGE_FILES_pre_trained/categories_for_tsne", full.names = T)
        
        list_cat_dfs <- vector(mode="list", length=length(tsne_cats))
        
        for(i in 1:length(tsne_cats)) {
            list_cat_dfs[[i]] <- read.csv(tsne_cats_file[i], stringsAsFactors = F)
        }
        
        cat_dfs <- dplyr::bind_rows(list_cat_dfs)
        
    
    # assign the label of the vector to its own variable
    t_glove$label <- names(glove)     
    head(t_glove)    
    
    
    
    # map in the category if applicable
    ?mapvalues
    t_glove$label %>% head()
    
        class(t_glove$label)
        class(cat_dfs$type)
    
    sum(t_glove$label %in% cat_dfs$type)
            
    t_glove$category <- plyr::mapvalues(x=t_glove$label, from=cat_dfs$type, to=cat_dfs$category)
    t_glove$category[!t_glove$category %in% cat_dfs$category] <- "other"  # if it didn't match, it shouldn't retain the "label" field
    t_glove$category %>% unique()    
    
    set.seed(1)
    t_glove_nocat <- t_glove[t_glove$category == "other",]
    t_glove_nocat <- t_glove_nocat[sample(1:nrow(t_glove_nocat), 10000),]
    t_glove_cat <- t_glove[t_glove$category != "other",]
    
    t_glove_subset <- rbind(t_glove_nocat, t_glove_cat)
    t_glove_subset$category <- as.factor(t_glove_subset$category)
    t_glove_subset_unlabeled <- t_glove_subset[, setdiff(names(t_glove_subset), c("label", "category"))]
    
    t_glove_subset$category
    
    # not sure how long this will take lol
    tsne <- Rtsne(t_glove_subset_unlabeled, dims = 2, perplexity=30, verbose=TRUE, max_iter = 500)    
    
    tsne$label <- t_glove_subset$label
    tsne$category <- t_glove_subset$category
    
    tsne
    
    colors = rainbow(length(unique(t_glove_subset$category)))    
    levels(t_glove_subset$category)
    colors = c("blue", "green", "orange", "gray")    
    
    plot(tsne$Y, t='n', main="tsne")
    points(tsne$Y, col=colors[t_glove_subset$category], pch=16)    
    
    
    
    