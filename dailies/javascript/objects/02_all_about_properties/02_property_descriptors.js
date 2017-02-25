'use strict';

// there is more to properties than just the value
// there are also properties of the property


// using an object literal for simplicity
var frog = {
    name: 'Jerry',
    color: 'Green'
};


// Object.getPropertyDescriptor( <object name>, <'property name'>);
console.log(Object.getOwnPropertyDescriptor(frog, 'name'))



// **************** Writable ***************************************
console.log('********* Writable');

// this one works, but I want to see if I can pass in my own obj
// Object.defineProperty(frog, 'name', {writable: false})


// create my own object
var myobjprop = {
    writable: false
}


// pass it in -- cool this one works too
//Object.defineProperty(frog, 'name', myobjprop);

frog.name = 'Ben';


// side note, properties can contain objects themselves, and if
// that is the case, it is better to use Object.freeze(frog.name)

//example:
var pc = {
    specs: {
        ram: '32gb',
        processor: 'i7'
    },
    type: 'desktop'
}

Object.defineProperty(pc, 'specs', {writable: false});
// pc.specs = 'this will fail';
pc.specs.ram = '16gb';  //this will not fail


// if we want to freeze the "specs" property which is an object:
Object.freeze(pc.specs);
// pc.specs.processor = 'i5';  // now this will fail

console.log("pc.specs object is frozen?  " + Object.isFrozen(pc.specs));




// ******************* Enumerable ************************************
console.log('********* Enumerable');

// redo the frog object
var frog = {
    name: {
        first: 'Jerry',
        last: 'Jeffreys'
    },
    color: 'Green'
}


// enumerable specifies which properties will show up when looping through
// properties and their values or displaying keys of an object

// loop through properties and values
console.log('looping through properties and prop values');
for (var prop in frog) {
    // first piece is getting prop name, next is prop value
    console.log(prop + ": " + frog[prop]);
}

// display keys
console.log('display object keys: ' + Object.keys(frog));
console.log('also JSON serialization');
console.log(JSON.stringify(frog));



// now if we set name to not be enumerable, it won't show up
Object.defineProperty(frog, 'name', {enumerable: false});
console.log('frog name is now not enumerable');
for (var prop in frog) {
    console.log(prop + ": " + frog[prop]);
}
console.log("object keys: " + Object.keys(frog));

console.log('now json serialization');
console.log(JSON.stringify(frog));



// ************* CONFIGURABLE ************************************************

// this controls whether we can change its other properties or if we can
// delete the property, once you make it not configurable, you cannot make
// it configurable again...


console.log('********* Configurable');

// rebuild our frog
var frog = {
    name: 'Jerry',
    color: 'Green'
}

Object.defineProperty(frog, 'name', {configurable: false});

// this will fail:
// Object.defineProperty(frog, 'name', {enumerable: false});


// this will also fail:
// delete frog.name;

// it defaulted to writable:
frog.name = 'Ben';
console.log("frogs name is now Ben: " + frog.name);

// you can still change the writable property though, which is interesting
Object.defineProperty(frog, 'name', {writable: false});
console.log("but you can't make it writable again...");

// this fails
//Object.defineProperty(frog, 'name', {writable: true});



