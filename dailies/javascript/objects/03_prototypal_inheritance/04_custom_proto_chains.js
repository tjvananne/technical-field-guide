'use strict';

// the order in which these events take place matters

// what we will demonstrate here is, we create a function
// for a new type of object that we will want to serve as
// the prototype object for another class


// Animal is prototype of Frog
// it will have more generic things that all animals have



// declare the Animal function (creates Animal prototype)
function Animal(sound) { 
    this.sound = sound || 'grunt'
}

// add a "speak" property to our Animal function's prototype obj
Animal.prototype.speak = function() {
    console.log(this.sound);
};


// declare the Frog function
function Frog(name, color, sound) {
    Animal.call(this, sound) // constructs Animal passing in this Frog instance
    this.name = name
    this.color = color
}


// silentBob will be a new Frog with default prototype object
var silentBob = new Frog('silent bob', 'green');
console.log(silentBob.__proto__);  // prints out "Object {}"
console.log(silentBob.constructor);  //function Frog(...)


// now we will reassign the Frog function's prototype object
// to be the Animal.prototype object we added "speak" to above
Frog.prototype = Object.create(Animal.prototype);


// we also want the constructor of future Frog objects to be the Frog function
// Object.create(Animal.prototype) switched the future Frog objects' constructor
// to animal, but we can switch it back to frog like this
Frog.prototype.constructor = Frog;


var jay = new Frog('jay', 'blue', 'hey, man, im jay');
console.log(jay.__proto__); // "Animal {}"
console.log(jay.constructor);  // was Animal until we fixed the constructor



// silentBob.speak();  //error, silentBob.speak() not a function
jay.speak();




