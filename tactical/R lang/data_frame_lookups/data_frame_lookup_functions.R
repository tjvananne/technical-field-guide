

# Taylor Van Anne
# 3/3/2017
# purpose is to have an easy function for looking up one or many values within a dataframe column
# where another dataframe column has a certain value we provide


# next step is to make this use data table for increased speed
#___________________________________________________________________________________________________




# in [df], find [val] in [field] and return me the values in [retfield]
# return_vector defaults to false to return a single item, but can be switched to true to return vector

record_lookup <- function(df, val, field, retfield, return_vector=F) {
    
    # type checking
    if(class(df) != "data.frame") {stop("first argument should be a data.frame -- eventually I'll allow other types")}
    if(!class(val) %in% c('integer', 'numeric', 'character', 'logical')) {warning("second argument should be a primitive data type")}
    if(length(val) != 1) {stop("second argument should have a length of 1")}
    if(length(field) != 1) {stop("third argument should have a length of 1")}
    if(length(retfield) != 1) {stop("fourth argument should have a length of 1")}
    if(class(field) != "character") {stop("third argument ('field') should be a character value representing a column in the dataframe")}
    if(class(retfield) != "character") {stop("third argument ('field') should be a character value representing a column in the dataframe")}
    
    # check if columns exist in df
    if(!field %in% names(df)) {stop("field (third argument) was not a valid column name within the dataframe")}
    if(!retfield %in% names(df)) {stop("field to be returned (fourth argument) was not a valid column name within the dataframe")}
    
    
    # this is the actual subset here
    myret <- df[, retfield][df[, field] == val]
    
    # if return_vector is false:
    if(!return_vector) {
        
        # then check if myret has more than 1 item
        if(length(myret) > 1) {
            
            # if so, limit it to 1 and give user a warning that multiple were found
            myret <- myret[[1]]
            warning("there were multiple fields found, only returning the first one")
        }
    } 
    
    # return NA if nothing found as opposed to an empty data type
    if(length(myret) == 0) {
        myret <- NA
    }
    
    
    # return myret (might be atomic, might be vector)
    return(myret)
}


# valid single value returned
record_lookup(iris, 7.9, "Sepal.Length", "Species")

# valid single value returned but multiple values found
record_lookup(iris, "virginica", "Species", "Sepal.Width")

# multiple values found and multiple returned
record_lookup(iris, "virginica", "Species", "Sepal.Width", return_vector=T)

# valid columns, but value to look up was not found (returns NA)
record_lookup(iris, "not found", "Species", "Sepal.Width")

# invalid column name (field)
record_lookup(iris, "virginica", "not a column name", "Sepal.Width")

# invalid column name (retfield - field to be returned)
record_lookup(iris, "virginica", "Species", "not a column name")

# not a dataframe
record_lookup("not a dataframe", "virginica", "Species", "Sepal.Width")

