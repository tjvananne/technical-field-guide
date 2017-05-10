

# Coursera Neural Networks -- Week 1 document 1


x1 <- 2; w1 <- 1
x2 <- -1; w2 <- -0.5
x3 <- 1; w3 <- 0

b <- 0.5  # this is bias

# sum the product of each respective input value and weight combination
sum_xw <- sum(x1 * w1 + x2 * w2 + x3 * w3)


# neuron calculations:


neuron_linear <- b + sum_xw
neuron_rectified_linear <- max(0, b + sum_xw)
neuron_binary_threshold <- ifelse(b + sum_xw >= 0, 1, 0)

# although most complicated, this is most common because it has smooth derivatives all over which are good for learning
neuron_sigmoid <- 1 / (1 + (exp(-(b + sum_xw))))  # 1 over (1 plus (e to the negative z));  where z == b + sum_xw

    # breakdown of above sigmoid...
    numerator <- 1
    z <- b + sum_xw
    denominator <- 1 + exp(-z) 
    numerator / denominator  # this is the output y for the neuron sigmoid

#' there is also a "stochastic binary neurons" which are the same as the logistic sigmoid neurons except that these will
#' generate a probability of producing an activation "spike" and then actually determine if that spike happens or not
#' based on some distribution... so think randomness here. If the input value is very large, then it is very likely
#' to generate a spike, if the input is very small then the chance of a spike is extremely low.
#' Stochastic binary neruons can also be modeled after the relu rectified linear neurons where the output (if above zero)
#' acts as the deterministic probability of producing a spike (using the Poisson rate for these spikes)

    
