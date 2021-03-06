<p align="center">
  <img width="150" height="150" src="https://github.com/AmineToualbi/ClimaCloset/blob/master/ClimaCloset/Images.xcassets/AppIcon.appiconset/Icon-App-60x60%403x.png">
</p>

# ClimaCloset

Clima Closet is an iOS app targeted towards children to teach them how to dress based on the weather. 



# Functionality

When the app is opened and brought to the foreground, Clima Closet retrieves the GPS coordinates of the phone and communicates with OpenWeatherMap's REST API to retrieve weather data. 

Based on the current weather conditions, an adequate outfit is generated. 

The user has the choice to change the city to get a different outfit for this new city.  

Communication is handled using Alamofire and the JSON data is parsed using SwiftyJSON. 

Other libraries are used for UI enhancement such as SVProgressHUD and for functionality such as LatLongToTimezone. 



# UI

The app presents an intuitive UI with three tabs that are accessed through swipe motion. 

The background of the app adapts based on the time of the day. For instance, at night, it will take a darker tone. The time the sun sets and rises is determined with the REST API. 

The main view presents a screen with the temperature, the weather condition, the city currently used, and a switch (SegmentedControl) to specify the unit system. 

A second view is used to specify a city if the user would like to check the weather and adequate outfit for a location different than his current. 

The third view generates an outfit based on data retrieved from the REST API. 

![alt text](http://image.noelshack.com/fichiers/2019/18/1/1556564336-climacloset1.png)

![alt text](http://image.noelshack.com/fichiers/2019/18/1/1556564336-climacloset2.png)

![alt text](http://image.noelshack.com/fichiers/2019/18/1/1556564336-climacloset3.png)

![alt text](http://image.noelshack.com/fichiers/2019/18/1/1556564336-climacloset4.png)


