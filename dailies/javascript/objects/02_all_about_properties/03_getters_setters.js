'use strict';


var frog = {
    name: {
        first: 'Jerry',
        last: 'Smith'
    },
    color: 'Green'
}


// how to define a "getter" on an existing object
// Object.defineProperty(<object>, <'prop name'>, <obj definition of property>)
Object.defineProperty(frog, 'fullName', {
    get: function() {
        return this.name.first + ' ' + this.name.last
    },
    // you can define getter and setter all in one fell swoop
    set: function(myvalue) {
        var nameParts = myvalue.split(' ')
        this.name.first = nameParts[0]
        this.name.last = nameParts[1]
    }
})


console.log(frog.fullName);

// set name to something else:
frog.fullName = "Mister Tea";  // setter
console.log(frog.fullName);    // getter
console.log(frog.name.first);  // normal property value
console.log(frog.name.last);   // normal property value





// ************** at object creation time **********************

// from mozilla: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/get


// this is how to add the getter at the time you create the object
// this getter gets the most recent item in the "log" property array
// if it is empty, it returns an undefined

var obj = {
  log: ['dev', 'test', 'prod'],
  get latest() {
    if (this.log.length == 0) return undefined;
    return this.log[this.log.length - 1];
  }
}

// note there is no need to put "()" after the function name
console.log(obj.latest); // Will return "test"

