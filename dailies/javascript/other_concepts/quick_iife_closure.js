


// really cool example from stack overflow
// http://stackoverflow.com/questions/20918030/javascript-closure-and-iife-immediately-invoked-function-expressions


// the idea is that we want to capture the value of "i" at a point in time
// changing the value of "i" will not impact the stored value from function f


var i = -1;
var f = (function(state) { // this will hold a snapshot of i
            return function() {
               return state; // this returns what was in the snapshot
            };
         })(i); // here we invoke the outermost function, passing it i (which is -1).
                // it returns the inner function, with state as -1
i = 1; // has no impact on the state variable
f(); // now we invoke the inner function, and it looks up state, not i



