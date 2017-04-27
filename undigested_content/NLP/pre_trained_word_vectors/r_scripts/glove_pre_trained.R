

# using a glove pretrained word vector 

# set working dir and read in file
    library(rstudioapi)
    setwd(dirname(dirname(rstudioapi::getActiveDocumentContext()$path)))
    
    list.dirs()
    list.files("pre_trained")
    
    g6b <- scan(file = "pre_trained/glove.6B.50d.txt", what="", sep="\n")
    
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

    library(Rtsne)
        
    