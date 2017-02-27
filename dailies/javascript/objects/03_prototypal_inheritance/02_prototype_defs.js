'use strict';


/*
A functions prototype is the object instance 
that will become the prototype for all objects 
created using this function as a constructor
    console.log(myFunction.prototype);


An objects prototype is the object instance from
which the object is inherited
    console.log(myObject.__proto__);
    
    
//-----------------------------------------------


so when a function is created, it gets a prototype
object created and attached to it behind the scenes.
When that function is used as a constructor to create
a new object, the prototype object is used to inherit

*/



function Frog(name, color) {
    this.name = name
    this.color = color
}

var myFrog = new Frog('Jerry', 'Green');
console.log(myFrog);


console.log(myFrog.__proto__);
console.log(Frog.prototype);


// not only do they look identitcal, but they are actually
// the exact same instance 
// this would only return true if they are the same instance
console.log(myFrog.__proto__ === Frog.prototype);

//---------------------------------------------------


// If I make changes to the Frog function's prototype,
// it will show up on the myFrog object's __proto__ property
Frog.prototype.age = 7;

console.log('age should now be 7 for prototype object');
console.log(Frog.prototype);
console.log(myFrog.__proto__);









