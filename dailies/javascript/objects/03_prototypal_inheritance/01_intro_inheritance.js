'use strict';

console.log('testing');





// lets say I have an array:
var myarray = ['green', 'blue', 'red'];


    //bonus info: this is exactly the same as above
    // var myarray = new Array('green', 'blue', 'red'); 



// now lets say I want to access the last item in the array
console.log(myarray[myarray.length - 1]);

//---------------------------------------------------------

// that is great, but can we make that a property of the obj?
Object.defineProperty(myarray, 'last', {
    get: function() {
        return this[this.length - 1]
    }
});

var last = myarray.last
console.log('using my new property: ' + last);


//----------------------------------------------------------

// awesome, but now I want to create a new array object and
// still have that same functionality... so now we must
// edit the PROTOTYPE of the array object itself

var arr2 = ['apple', 'banana', 'orange'];


// doesn't work, this returns "undefined"
console.log('with a new array: ' + arr2.last);


//---------------------------------------------------------


// here we are editing the prototype object of the array
Object.defineProperty(Array.prototype, 'last', {
    get: function() {
        return this[this.length - 1]
    }
});


// from now on, newly constructed arrays will receive this new
// 'last' property which calculated which item is last in array
var arr3 = ['dog', 'cat', 'bird'];
console.log('with new array after proto fix: ' + arr3.last);

