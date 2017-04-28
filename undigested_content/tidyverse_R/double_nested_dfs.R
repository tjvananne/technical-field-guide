

# a double nest DF, what does it mean??
# http://stackoverflow.com/questions/39228502/double-nesting-in-the-tidyverse


library(gapminder)
library(purrr)
library(tidyr)
library(broom)
library(dplyr)

gapminder = gapminder


nest_data <- gapminder %>% 
    group_by(continent) %>% 
    nest(.key = by_continent) 

#' Is there a reason you can't simply nest after grouping by both continent and country? That seems 
#' like it would be more straightforward to work with. If you really want the nested list columns, 
#' how about nest_data %>% mutate(by_continent = map(by_continent, ~.x %>% group_by(country) %>% 
#' nest(.key = by_country)))? - aosmith Aug 30 '16 at 14:51
#' 
#' Appreciate your help. The structure is just a matter of trying to understand the list 
#' columns. Your command worked like a charm. However, I'm uncertain as to if I understand 
#' why. I tried something similar, but with just ~. instead of ~.x . What does the x do? 
#' Furthermore, If I now want to run a regression for each and every country without resorting
#' to unnesting and have the result in by_country how can that be done?
#' 
#' I've seen both . and .x used in map, but I usually use .x because that's what is in the 
#' documentation. Maybe the . is confused here due to the mutate wrapper? In terms of models
#'  by country from nested tibbles in columns, things got messy fast. I got to 
#'  mutate(nested_again, models = map(by_continent, "by_country") %>% at_depth(2, ~lm(lifeExp ~ year, 
#'  data = .x))).

nested_again <- nest_data %>% 
    mutate(by_continent = map(by_continent, ~.x %>% 
                                                group_by(country) %>% 
                                                nest(.key = by_country)))

?map

nested_again
nested_again %>% unnest
