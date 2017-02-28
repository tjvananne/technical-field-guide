'use strict';



// 2) Inner functions can refer to variables defined in outer functions even after the latter have returned


function setLocation(city) {
    var country = "France";
    
    
    // this function will have access to the "country" variable
    function printLocation() {
        console.log("You are in " + city + ", " + country);
    }
    
    
    // return the actual function, not just what it returns
    return printLocation;
    
}



// setLocation returns a callable function -- the function still has access to "country"
// the "country" reference was available at the time "printLocation" was declared, so it is available now even
// after setLocation() is done executing and has returned
var currentLocation = setLocation("Paris");


// call it
currentLocation();




