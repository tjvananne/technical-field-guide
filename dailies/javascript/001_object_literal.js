'use strict';

// Pluralsight Javascript objects and prototypes

// use strict helps keep you from common errors



// object literal means you create the object and assign its values in one fell swoop
var frog = {
    name: 'Jerry', 
    color: 'Green',
    talk: function() {
        console.log('Hello, I am Jerry')
    }
}

// you can assign other properties like this
frog.age = 3

// and assign it a method like this
frog.speak = function() {
    console.log('Ribbit!');
}


// notice that object methods can be placed on the object literall at time
// of creating the object OR later on (such as the speak method above)


// use dot notation to access the properties of the object
console.log(frog.age);
console.log(frog.name);
frog.speak();
frog.talk();