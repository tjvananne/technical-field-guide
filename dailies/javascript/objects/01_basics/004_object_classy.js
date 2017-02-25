'use strict';

// this is the new ECMA 16 way to create objects that is more java like


// this is just syntactic sugar, it really does the same thing

class Frog {
    
    // constructor is a named keyword now, add properties here
    constructor(name, color) {
        this.name = name
        this.color = color
    }
    
    // add methods below
    speak() {
        console.log("Ribbit!")
    }
}


var myfrog = new Frog('Jerry', 'Green');

console.log(myfrog);
myfrog.speak();



