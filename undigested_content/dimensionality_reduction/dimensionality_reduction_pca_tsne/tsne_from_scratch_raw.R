


# helper functions -------

# ORIGINAL hbeta
    .Hbeta <-
        function(D, beta){
            P = exp(-D * beta)
            sumP = sum(P)
            if (sumP == 0){
                H = 0
                P = D * 0
            } else {
                H = log(sumP) + beta * sum(D %*% P) /sumP
                P = P/sumP
            }
            r = {}
            r$H = H
            r$P = P
            r
        }

# ORIGINAL x2p
    .x2p <-
        function(X,perplexity = 15,tol = 1e-5){
            if (class(X) == 'dist') {
                D = X
                n = attr(D,'Size')
            } else{
                D = dist(X)
                n = attr(D,'Size')
            }
            
            D = as.matrix(D)
            P = matrix(0, n, n )		
            beta = rep(1, n)
            logU = log(perplexity)
            
            for (i in 1:n){
                betamin = -Inf
                betamax = Inf
                Di = D[i, -i]
                hbeta = .Hbeta(Di, beta[i])
                H = hbeta$H; 
                thisP = hbeta$P
                Hdiff = H - logU;
                tries = 0;
                
                while(abs(Hdiff) > tol && tries < 50){
                    if (Hdiff > 0){
                        betamin = beta[i]
                        if (is.infinite(betamax)) beta[i] = beta[i] * 2
                        else beta[i] = (beta[i] + betamax)/2
                    } else{
                        betamax = beta[i]
                        if (is.infinite(betamin))  beta[i] = beta[i]/ 2
                        else beta[i] = ( beta[i] + betamin) / 2
                    }
                    
                    hbeta = .Hbeta(Di, beta[i])
                    H = hbeta$H
                    thisP = hbeta$P
                    Hdiff = H - logU
                    tries = tries + 1
                }	
                P[i,-i]  = thisP	
            }	
            
            r = {}
            r$P = P
            r$beta = beta
            sigma = sqrt(1/beta)
            
            message('sigma summary: ', paste(names(summary(sigma)),':',summary(sigma),'|',collapse=''))
            
            r 
        }

    
# ORIGINAL whiten
    .whiten <-
        function(X, row.norm=FALSE, verbose=FALSE, n.comp=ncol(X)) {  
            n.comp; # forces an eval/save of n.comp
            if (verbose) message("Centering")
            n = nrow(X)
            p = ncol(X)
            X <- scale(X, scale = FALSE)
            X <- if (row.norm) 
                t(scale(X, scale = row.norm))
            else t(X)
            
            if (verbose) message("Whitening")
            V <- X %*% t(X)/n
            s <- La.svd(V)
            D <- diag(c(1/sqrt(s$d)))
            K <- D %*% t(s$u)
            K <- matrix(K[1:n.comp, ], n.comp, p)
            X = t(K %*% X)
            X
        }


    # -- my test test whiten
        my_X <- matrix(1:81, ncol=3)
        my_X
        .whiten(my_X)


# ORIGINAL TSNE
tsne <-
    function(X, initial_config = NULL, k=2, initial_dims=30, perplexity=30, max_iter = 1000, min_cost=0, epoch_callback=NULL,whiten=TRUE, epoch=100 ){
        if ('dist' %in% class(X)) {
            n = attr(X,'Size')
        }
        else 	{
            X = as.matrix(X)
            X = X - min(X)
            X = X/max(X)
            initial_dims = min(initial_dims,ncol(X))
            if (whiten) X<-.whiten(as.matrix(X),n.comp=initial_dims)
            n = nrow(X)
        }
        
        momentum = .5
        final_momentum = .8
        mom_switch_iter = 250
        
        epsilon = 500
        min_gain = .01
        initial_P_gain = 4
        
        eps = 2^(-52) # typical machine precision
        
        if (!is.null(initial_config) && is.matrix(initial_config)) {
            if (nrow(initial_config) != n | ncol(initial_config) != k){
                stop('initial_config argument does not match necessary configuration for X')
            }
            ydata = initial_config
            initial_P_gain = 1
            
        } else {
            ydata = matrix(rnorm(k * n),n)
        }
        
        P = .x2p(X,perplexity, 1e-5)$P
        P = .5 * (P + t(P))
        
        P[P < eps]<-eps
        P = P/sum(P)
        
        P = P * initial_P_gain
        grads =  matrix(0,nrow(ydata),ncol(ydata))
        incs =  matrix(0,nrow(ydata),ncol(ydata))
        gains = matrix(1,nrow(ydata),ncol(ydata))
        
        for (iter in 1:max_iter){
            if (iter %% epoch == 0) { # epoch
                cost =  sum(apply(P * log((P+eps)/(Q+eps)),1,sum))
                message("Epoch: Iteration #",iter," error is: ",cost)
                if (cost < min_cost) break
                if (!is.null(epoch_callback)) epoch_callback(ydata)
                
            }
            
            sum_ydata = apply(ydata^2, 1, sum)
            num =  1/(1 + sum_ydata +    sweep(-2 * ydata %*% t(ydata),2, -t(sum_ydata)))
            diag(num)=0
            Q = num / sum(num)
            if (any(is.nan(num))) message ('NaN in grad. descent')
            Q[Q < eps] = eps
            stiffnesses = 4 * (P-Q) * num
            for (i in 1:n){
                grads[i,] = apply(sweep(-ydata, 2, -ydata[i,]) * stiffnesses[,i],2,sum)
            }
            
            gains = ((gains + .2) * abs(sign(grads) != sign(incs)) +
                         gains * .8 * abs(sign(grads) == sign(incs)))
            
            gains[gains < min_gain] = min_gain
            
            incs = momentum * incs - epsilon * (gains * grads)
            ydata = ydata + incs
            ydata = sweep(ydata,2,apply(ydata,2,mean))
            if (iter == mom_switch_iter) momentum = final_momentum
            
            if (iter == 100 && is.null(initial_config)) P = P/4
            
        }
        ydata
    }



# my test execution of the tsne algorithm:

iris.x <- iris[,-5]
iris.y <- iris[,5]
iris.tsne <- tsne(iris.x, initial_dims=2, perplexity = 10)

library(ggplot2)
class(iris.tsne)
df.tsne = data.frame(iris.tsne)  
ggplot(df.tsne, aes(x=X1, y=X2, color=iris.y)) + geom_point(size=2)

