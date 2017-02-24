'use strict';

/* so everything we have learned so far is just syntactic sugar for this
concept we are about to cover right now. Under the hood, when we construct
our object with "new" and "this", we are really just calling an 
"Object.create(Object.prototype, {<our object here>})" expression
*/


/*
function Frog(name, color) {
    this.name = name
    this.color = color
}

var frog = new Frog('Jerry', 'Green')
*/


// this is the equivalent as what is above right there
var frog = Object.create(Object.prototype,
    {
        name: {
            value: 'Jerry',
            enumerable: true,
            writable: true,
            configurable: true
        },  // end of name property object  
    
        color: {
            value: 'Green',
            enumerable: true,
            writable: true,
            configurable: true
        }  // end of color property object  
    
    } // end of the object we are passing in
                         
)  // end of Object.create() function





// **************************************************************************
// just to simplify what the Object.create(Object.prototype, {}) function 
// looks like, we'll save our object literal to be used as a prototype in
// its own object literal



// so we could also have stored that in an object itself
myobj = {
    name: {
            value: 'Jerry',
            enumerable: true,
            writable: true,
            configurable: true
        },  // end of name property object  
    
        color: {
            value: 'Green',
            enumerable: true,
            writable: true,
            configurable: true
        }  // end of color property object  
}

var frog2 = Object.create(Object.prototype, myobj);
