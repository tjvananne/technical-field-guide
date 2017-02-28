'use strict';


// great breakdown on closures from sitepoint:
// https://www.sitepoint.com/demystifying-javascript-closures-callbacks-iifes/


// from MDN Mozilla:
// A closure is the combination of a function and the lexical environment within which that function was declared.



// 1) You can refer to variables defined outside of the current function


function setLocation(city) {
    var country = "France";
    
    
    // this function will have access to the "country" variable
    function printLocation() {
        console.log("You are in " + city + ", " + country);
    }
    
    
    // returning whatever is returned from printLocation()
    return printLocation();
    
}



setLocation("Paris");





