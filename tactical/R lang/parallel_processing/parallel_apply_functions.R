
# resources:
# http://gforge.se/2015/02/how-to-go-parallel-in-r-basics-tips/
# sessionInfo()  3.3.2 64-bit


library(parallel)  # this package is a built-in R package


# calculate number of cores:
num_cores <- parallel::detectCores() - 1

