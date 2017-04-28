
# my first chronologically run interaction with "blogdown"
# http://stackoverflow.com/questions/26570912/error-in-installation-a-r-package 


# 1) load devtools and attempt install
    library(devtools)
    
    # this failed because of a dependency "digest" from "knitr"
    devtools::install_github("rstudio/blogdown")

    
    
# 2) install dependency "digest" manually
    install.packages("digest")
    
    #' "Cannot remove prior installation of package 'digest'"
    
    
# 3) I can't "library('digest')" because "there is no package
    # called digest"

# ) try install again
    devtools::install_github("rstudio/blogdown")


library(blogdown)
