
#https://www.r-bloggers.com/computing-and-visualizing-pca-in-r/

# libraries -------------------------------------------------------------------------------

#install.packages('Rtsne')
library(Rtsne)
library(devtools)
#install_github("ggbiplot", "vqv")
library(ggbiplot)



# helper functions ------------------------------------------------------------------------

    # base pairwise plot 
    my_quickplot <- function(param_df, param_title=NULL) {
        plot(param_df, pch=16, col=rgb(0, 0, 0, 0.2), main = param_title)
    }
    
    
    # helper pca plot  
    my_quickpca <- function(param_df, param_title=NULL) {
        g <- ggbiplot(param_df, obs.scale = 1, var.scale = 1, groups = ir.species, ellipse=TRUE, circle = TRUE)
        g <- g + theme(legend.direction = 'horizontal', legend.position = 'top')
        if(!is.null(param_title)) {g <- g + ggtitle(param_title)}
        return(g)
    }


# preprocessing and pairwise plots -------------------------------------------------------------


my_quickplot(iris, "Iris -- No Preprocessing")


# first, preprocess:
raw.ir <- iris[,1:4]
log.ir <- log(iris[, 1:4])     # just log
scale.ir <- scale(iris[, 1:4]) # just centered / scaled
log.scale.ir <- scale(log.ir)
ir.species <- iris[, 5]  # separate categorical var

df.log.ir <- data.frame(cbind(log.ir, ir.species))
df.scale.ir <- data.frame(cbind(scale.ir, ir.species))
df.log.scale.ir <- data.frame(cbind(log.scale.ir, ir.species))


my_quickplot(df.scale.ir, "Iris -- Scaled Data")       # no positional change to data, just axis basically
my_quickplot(df.log.ir, "Iris -- Log of Numeric Data") # log data
my_quickplot(df.log.scale.ir, "Iris -- Scaled the Log of Numeric Data") # hopefully same as prcomp()



# apply pca 


# first just scaled data
    scale.ir.pca <- prcomp(scale.ir, center = TRUE, scale. = TRUE)
    #plot(scale.ir.pca, type="l")  # most of the variability is explained by first two principal components
    #predict(scale.ir.pca, newdata=tail(scale.ir, 2))
    my_quickpca(scale.ir.pca, "Scaled")  # might need to wrap in a "print()" statement to send to graphics device


# now just the raw data
    raw.ir.pcs <- prcomp(raw.ir, center = F, scale.=F)
    my_quickpca(raw.ir.pcs, "Raw Data -- No Transformation")
    # PC1 explains 96.5% of the variance... in this case maybe it is best to not log or scale?
    
    
# feed raw data into prcomp but use center / scale. = true
    raw.ir.pca_scaled <- prcomp(raw.ir, center=T, scale.=T)
    my_quickpca(raw.ir.pca_scaled, "Raw Data -- Scaled in prcomp()")
    # so no difference in whether data is pre-scaled or not... that is good
    
# feed log'd data into prcomp with scale/center to false
    log.ir.pca <- prcomp(log.ir, center=F, scale.=F)
    my_quickpca(log.ir.pca, "Log of Data -- No Scale or Center")
    # separation doesnt look too bad, but we are very off-center
    
# log'd data with scale/center to true
    log.scale.ir.pca <- prcomp(log.ir, center=T, scale.=T)
    my_quickpca(log.scale.ir.pca, "Scaled Log of Data")
    