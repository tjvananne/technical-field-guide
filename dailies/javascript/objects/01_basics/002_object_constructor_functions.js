'use strict';

// same course

function Frog() {
    this.name = 'Jerry'
    this.color = 'Green'
}


// "this" refers to whichever object is currently executing code


var frog = new Frog();

// the "new" keyword creates a new object of the type you specify and 
// sets the execution context to that new object


/* Technically, the Frog function does not return anything except for the
"undefined" value. It is the "new" keyword that is returning a new instance
of whatever function object constructor we pass in afterwards.


If we were to have left off the "new" keyword, then the object referred to by
the "this" keyword within the Frog function would be the window (if we were
running this in the browser). That is because window is the global object when
running in the browser. So we would effectively be changing the name of the 
window to "Jerry" and the color property to "Green" (wouldn't actually change
the color of the browser screen to green though).

So "new" is critical to setting the execution context to that of the new object
we are creating.
*/


// ***************************************************************************

// ok well now we don't want ever frog to be named Jerry and be Green:


// also note that there are no commas to end each line, we are not creating
// an object literal here, these are just lines of code to execute in a function
function Frog2(name, color) {
    this.name = name
    this.color = color
}

// these are commonly called constructor functions, but there really is
// nothing special about them, they are just functions. The special sauce
// is in the combination of the "this" keyword and the "new" keyword


// this is just a very common pattern for creating objects

var jerry = new Frog2('Jerry', 'Blue');

console.log(jerry.name);
console.log(jerry.color);



