'use strict';


var frog = {
    name: 'Jerry',
    color: 'Green'
}


// you can access properties using dot notation or bracket notation
console.log(frog.name);
console.log(frog['color']);


// dot notation is preferable because it is easy
// bracket notation is useful for illegal names


// this property has a space in it, we can't use dot notation
frog['Eye Color'] = 'Blue';

console.log("Eye Color is: " + frog['Eye Color']);


// reason you might want to do this is if you have a user entered
// value that  you want to be the property name, or  you have a 
// json file where you pull property names and some are not valid identifiers