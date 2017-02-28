'use strict';



// 3) Inner functions store their outer function's variables by reference, not by value
// (this is how / why getters and setters work)


// using sett and gett to show that "set" and "get" are not named keywords


function cityLocation() {
    var city = "Paris";
    
    
    
    //return an object full of methods for interacting with this data
    return {
        
        // these are just key: value pairs in an object literal that is being returned
        gett: function() { console.log(city); },
        sett: function(newCity) {
            city = newCity;
            console.log('city has been set to: ' + newCity);
        }
        
    }
    
}



var myLocation = cityLocation();

myLocation.gett();
myLocation.sett('Sydney');
myLocation.gett();



