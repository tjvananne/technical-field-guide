'use strict';


/*
When you access an objects property, it will first look at
the actual instance of that object to see if it has
that property attached to it. If it does not, then it will
climb up the prototypal inheritance chain until it finds
the property you are wanting to access
*/


function Frog(name, color) {
    this.name = name
    this.color = color
}


Frog.prototype.age = 8;

var frog1 = new Frog('frog1', 'green');
var frog2 = new Frog('frog2', 'blue');


frog2.age = 3;


console.log(frog1.age);            // 8
console.log(frog2.age);            // 3
console.log(frog2.__proto__.age);  // 8


// in the first statement, frog1 does not really have
// an 'age' property, only it's prototype does


    //--------------------------------------------------------
    //side notes:
    
    // we can see this by using the hasOwnProperty function
    console.log('frog1 has age property?: ' + frog1.hasOwnProperty('age'));
    //frog1 has age property?: false

    // shouldn't show up in Object.keys
    console.log("below are frog 1 object keys, shouldn't contain 'age'");
    console.log(Object.keys(frog1));

    // interestingly, if we enumerate it's keys, the prototype value
    // actually does show up
    for (var prop in frog1) {
        console.log(prop + ': ' + frog1[prop]);
    };
    // returns name: frog1, color: green, age: 8

    // it does not show up if you serialize json though... this is weird
    console.log(JSON.stringify(frog1));
    // returns {"name":"frog1","color":"green"}


    //---------------------------------------------------------------


console.log('frog2 has age property?: ' + frog2.hasOwnProperty('age'));
// frog2 has age property?: true


// so essentially when we are trying to access the age of these 
// frogs, it first looks at the actual instance of the frog
// we created, if it doesn't find it there (such as for frog1), 
// then it will look to the prototype for the property.



// takeaway, just because you get a property value returned
// to you doesn't mean that that object has that property, 
// it could be that some object in it's prototype chain has it.


// instance properties always override prototype properties
