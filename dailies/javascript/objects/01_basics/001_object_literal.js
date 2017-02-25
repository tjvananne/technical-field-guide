'use strict';

// Pluralsight Javascript objects and prototypes

// use strict helps keep you from common errors (disallows depracated 
// parts of the scripting language



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


// ***************************************************************
// from mozilla literals: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Grammar_and_types#Literals


// object literal property values can come in many forms:

var sales = 'Toyota';

function carTypes(name) {
    if (name === 'Honda') {
        return name;
    } else {
        return "Sorry, we don't sell " + name + ".";
    }
}


var car = {
    myCar: 'Saturn',             # literal string value
    getCar: carTypes('Honda'),   # from a function's return statement
    varCar: sales                # from a previously declared var
};



// ************* ES2015 changes ********


// can access the prototype object from a literal object declaration now
// can also add handler
// can add methods as well

var obj = {
    // __proto__
    __proto__: theProtoObj,
    // Shorthand for ‘handler: handler’
    handler,
    // Methods
    toString() {
     // Super calls
     return 'd ' + super.toString();
    },
    // Computed (dynamic) property names
    [ 'prop_' + (() => 42)() ]: 42
};



