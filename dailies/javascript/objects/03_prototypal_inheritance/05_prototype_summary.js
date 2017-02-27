'use strict';


// only the essentials for clarity




// parent object function constructor and its prototype
function Animal(sound) {
    this.sound = sound || 'grunt'
}

Animal.prototype.speak = function() {
    console.log(this.sound)
}



// child object function constructor
function Frog(name, color, sound) {
    Animal.call(this, sound)  //call the parent with any pass-ins necessary
    this.name = name
    this.color = color
}


// now set the prototype of the Frog prototype equal to the Animal prototype
Frog.prototype = Object.create(Animal.prototype);

//fix the Frog prototype constructor
Frog.prototype.constructor = Frog;



var jay = new Frog('Jay', 'Green', 'Hey man');

console.log(jay.name);
console.log(jay.color);
jay.speak();






