

# gradient descent algorithm implemented in R:

# this is specifically for linear algorithms though, but it will still be interesting to learn
# https://sw23993.wordpress.com/2017/02/12/implementing-the-gradient-descent-algorithm-in-r/ 


# his definition of the line equation is using these variables:
# y = mx + c    (m is slope coefficient, x is variable, c is intercept)

# original
gradientDesc <- function(x, y, learn_rate, conv_threshold, n, max_iter) {
    plot(x, y, col = "blue", pch = 20)
    m <- runif(1, 0, 1)
    c <- runif(1, 0, 1)
    yhat <- m * x + c
    MSE <- sum((y - yhat) ^ 2) / n
    converged = F
    iterations = 0
    while(converged == F) {
        print(iterations)
        ## Implement the gradient descent algorithm
        m_new <- m - learn_rate * ((1 / n) * (sum((yhat - y) * x)))
        c_new <- c - learn_rate * ((1 / n) * (sum(yhat - y)))
        m <- m_new
        c <- c_new
        yhat <- m * x + c
        MSE_new <- sum((y - yhat) ^ 2) / n
        if(MSE - MSE_new <= conv_threshold) {
            abline(c, m) 
            converged = T
            return(paste("Optimal intercept:", c, "Optimal slope:", m))
        }
        iterations = iterations + 1
        if(iterations > max_iter) { 
            abline(c, m) 
            converged = T
            return(paste("Optimal intercept:", c, "Optimal slope:", m))
        }
    }
}


my_gradientDesc <- function(x, y, learn_rate, conv_threshold, n, max_iter) {
    plot(x, y, col = "blue", pch = 20)
    m <- runif(1, 0, 1)
    c <- runif(1, 0, 1)
    yhat <- m * x + c
    MSE <- sum((y - yhat) ^ 2) / n
    converged = F
    iterations = 0
    while(converged == F) {
        
        # this is my addition, every 1000...
                # optional- create new plot with number of iterations listed
                # mark the current best fit line
            # or just add the line to existing plot so we have a ton of lines
        if(iterations %% 30000 == 0) {
            plot(x, y, col = "blue", pch = 20, main=paste0("iteration: ", iterations))
            abline(c, m)
            Sys.sleep(1)
        }
        
        print(iterations)
        ## Implement the gradient descent algorithm
        m_new <- m - learn_rate * ((1 / n) * (sum((yhat - y) * x)))
        c_new <- c - learn_rate * ((1 / n) * (sum(yhat - y)))
        m <- m_new
        c <- c_new
        yhat <- m * x + c
        MSE_new <- sum((y - yhat) ^ 2) / n
        
        # break statements
        if(MSE - MSE_new <= conv_threshold) {
            abline(c, m) 
            converged = T
            return(paste("Optimal intercept:", c, "Optimal slope:", m))
        }
        iterations = iterations + 1
        if(iterations > max_iter) { 
            abline(c, m) 
            converged = T
            return(paste("Optimal intercept:", c, "Optimal slope:", m))
        }
    }
}



# Run the function 
set.seed(1)
#gradientDesc(mtcars$disp, mtcars$mpg, 0.0000293, 0.001, 32, 2500000)
my_gradientDesc(mtcars$disp, mtcars$mpg, 0.0000293, 0.001, 32, 2500000)


