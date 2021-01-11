# MyPhotography


## Features
1. Generic based tiny reactive networking library
2. Codable Model objects
3. Demonstrates MVVM pattern with Rx binding
4. Uses repository pattern as an abstraction over data access and persitence logic

## Assumptions
1. Locations can only be added from map view by long pressing on the map.
2. Latitudes and longitudes are non editable. Only name and notes are editable for local/user-added loactions.
3. Locations can not be deleted. 
4. There is no check for uniqueness of the locations while being added. Multiple locations can be added for the same latitude and longitude. 

## TODO
1. Sort by distance. Ideally it'll be done in the viewmodel where an observable of current location is injected and the location array updates based on a new location
2. Coordinators: To handle app navigation
3. Better error handling
4. More unit tests
