
# resources: http://www.theprojectspot.com/tutorial-post/creating-a-genetic-algorithm-for-beginners/3

#' 1) initialize population with random attributes / parameters / genes
#' 2) evaluate fitness and assign procreation probability
#' 3) selection for procreation -- fittest have best probability of procreation
#' 4) crossover: blend the attributes of the parents to create a child
#' 5) mutation: allow for slight random variation in addition to blending
#' 6) repeat until we hit a termination clause / statement
#' 
#' Termination can be brought on by achieving a goal we set, hitting a
#' maximum number of iterations we set, or hitting a number of rounds without
#' a certain threshold of improvement


################################################################################################
# Function Definitions for genetic algorithm ===================================================


# for creating a single individual:
generate_individual <- function(indi_size = 63) {
    random_numbs <- runif(indi_size, min = 0.0001, max = 1)
    temp_indi <- paste0(sapply(random_numbs, round), collapse='')
    return(temp_indi)
}



# for generating a population of individuals (still need to specify individual's size):
generate_population <- function(pop_size, indi_size) {
    pop <- character(pop_size)
    for(i in 1:pop_size) {
        temp_indi <- generate_individual(indi_size)
        pop[i] <- temp_indi
    }
    return(pop)
}



# calculate fitness for a single individual:
calc_fitness <- function(indi, solu) {
    indi_split <- strsplit(indi, '')[[1]]
    solu_split <- strsplit(solu, '')[[1]]
    fitness <- 0
    for(i in 1:length(indi_split)) {
        if(indi_split[i] == solu_split[i]) {
            fitness <- fitness + 1
        }
    }
    return(fitness)
}



# finds the fittest individual within a population of individuals
find_fittest <- function(pop, solu) {
    
    # what is the max fitness of this group and how many have that value
    all_fit_list <- sapply(pop, calc_fitness, solu=solu)
    max_fit <- max(all_fit_list)
    numb_fittest <- sum(all_fit_list == max_fit)
    
    # figure out the indeces where these exist
    fittest_indx <- which(all_fit_list == max_fit)
    
    # resolve ties if there are any (should only return single individual)
    if(numb_fittest > 1) {
        fittest_indi_indx <- round(sapply(1, runif, min=1, max=numb_fittest))
        single_fittest_indx <- fittest_indx[fittest_indi_indx]
        fittest_indi <- pop[single_fittest_indx]
    } else {
        fittest_indi <- pop[fittest_indx]
    }
    return(c(fittest_indi, as.integer(max_fit)))
}



# optional function for mutation of individuals:
mutate_indi <- function(indi, mutation_rate) {
    indi_chars <- strsplit(indi, '')[[1]]
    rand_nums <- runif(nchar(indi), min=0, max=1)
    mutation_indx <- which(rand_nums <= mutation_rate)
    indi_chars[mutation_indx]
    mutate_1_to_0_indx <- mutation_indx[indi_chars[mutation_indx] == '1']
    mutate_0_to_1_indx <- mutation_indx[indi_chars[mutation_indx] == '0']
    indi_chars[mutate_1_to_0_indx] <- '0'
    indi_chars[mutate_0_to_1_indx] <- '1'
    
    new_indi <- paste0(indi_chars, collapse='')
    return(new_indi)
}



# conduct a tournament:
run_tournament <- function(pop, solu, tourney_size=5, verbose=F) {
    # take a sample of size tourney_size of the population pop and find the fittest 
    pop_size <- length(pop)
    rand_indi_indx <- round(sapply(rep(1, tourney_size), runif, min=1, max=pop_size))
    tourney_pop <- pop[rand_indi_indx]
        if(verbose) {print(tourney_pop)}
    winner_results <- find_fittest(tourney_pop, solu)
        if(verbose) {print(winner_results)}
    tourney_winner <- winner_results[[1]]
    return(tourney_winner)
}



# crossover genes -- this is the mating activity where 2 individuals create a child:
conduct_crossover <- function(indi1, indi2) {
    use_indi1_gene <- as.logical(round(sapply(rep(1, nchar(indi1)), runif, min=0.0001, max=1)))
    child_indi <- character(nchar(indi1))
    child_indi[use_indi1_gene] <- strsplit(indi1, '')[[1]][use_indi1_gene]
    child_indi[!use_indi1_gene] <- strsplit(indi2, '')[[1]][!use_indi1_gene]
    child_indi <- paste0(child_indi, collapse="")
    return(child_indi)
}



# generate the next generation population -- combine several functions to create child generation
evolve_generation <- function(population, solution, mutate_rate) {
    child_gen <- character(length(population))
    for(i in 1:length(population)) {
        winner1 <- run_tournament(pop = population, solu = solution, verbose = F)
        winner2 <- run_tournament(pop = population, solu = solution, verbose = F)
        child_of_winners <- conduct_crossover(winner1, winner2)
        child_of_winners <- mutate_indi(child_of_winners, mutation_rate = mutation_rate)
        child_gen[i] <- child_of_winners
    }
    return(child_gen)
}


################################################################################################
# helper functions for plotting population against solution ==================================

# convert a binary character string to RGB color vector (0-1 scale of values)
indi_to_color <- function(indi) {
    # this function takes in an individual binary character string and returns RGB values
    if(nchar(indi) %% 3 != 0) {
        stop("Error: please us an individual character size that is 
             divisible by three (for splitting into RGB values)")
    }
    rgb_max_chars <- nchar(indi) / 3
    rgb_max <- strtoi(paste0(rep(1, times=rgb_max_chars), collapse = ''), base=2)
    redbin <- substr(indi, 1, rgb_max_chars)
    greenbin <- substr(indi, (rgb_max_chars + 1), rgb_max_chars * 2)
    bluebin <- substr(indi, ((rgb_max_chars*2)+1), rgb_max_chars * 3)  
    redval <- round(strtoi(redbin, base=2) / rgb_max, digits=3)
    greenval <- round(strtoi(greenbin, base=2) / rgb_max, digits=3)
    blueval <- round(strtoi(bluebin, base=2) / rgb_max, digits=3)
    
    return(c(redval, greenval, blueval))
    }



# plot the population of individuals against the goal solution
plot_pop_against_goal <- function(pop, goal, iteration='', fitness='') {
    # initialize our starting y point and how much we should increment
    start_y <- 1
    increment_y <- 100 / length(pop)
    plot(x=-5, y=-5, xlim=c(1, 100), ylim=c(1, 100), xlab='', ylab='', xaxt='n', yaxt='n', 
         main=paste0('Population vs Goal  --  Iteration: ', iteration, '  --  best Fit: ', fitness))
    
    for(i in 1:length(pop)) {
        temp_rgbs <- indi_to_color(pop[i])
        rect(xleft=0, xright=50, ybottom=start_y, ytop=(start_y + increment_y), 
             col=rgb(temp_rgbs[1], temp_rgbs[2], temp_rgbs[3]))
        start_y <- start_y + increment_y
    }
    
    solution_rgb <- indi_to_color(goal)
    rect(xleft=50, xright=100, ybottom=1, ytop=100, col=rgb(solution_rgb[1], solution_rgb[2], solution_rgb[3]))
}



################################################################################################
# main =====

# set up our environment
population_size <- 50
solution <- generate_individual(indi_size = 90)
individual_size <- nchar(solution)
mutation_rate <- 0.02  # 0.01 means 1% chance for each gene in an individual to flip
crossover <- 0.5  # 0.5 takes half from each parent
tourney_size <- floor(individual_size / 10)


# set termination flags for our while loop
iterations <- 0
max_iterations <- 500
goal <- individual_size



# generate initial population and view it
pop_main <- generate_population(pop_size=population_size, indi_size=individual_size)
pop_main



# inspect fitness of initial, random population
current_results <- find_fittest(pop_main, solution)
print(current_results)
current_fit <- as.integer(current_results[[2]])





# plot the starting generation (basically the "do" of a "do-while")
plot_pop_against_goal(pop=pop_main, goal=solution, iteration=iterations, fitness=current_fit)
iterations <- iterations + 1


# keep looping until we hit a termination (very unlikely we will hit termination at first)
if(current_fit >= goal) {
    print('No need to continue, we met our goal on our first population!')
} else {
    
    # evolve generation
    while(iterations < max_iterations & current_fit < goal) {
        pop_main <- evolve_generation(population = pop_main, solution = solution, mutate_rate = mutate_rate)
        current_results <- find_fittest(pop_main, solution)
        print(current_results)
        current_fit <- as.integer(find_fittest(pop_main, solution)[[2]])
        plot_pop_against_goal(pop=pop_main, goal=solution, iteration=iterations, fitness=current_fit)
        
        iterations <- iterations + 1
    }
}




