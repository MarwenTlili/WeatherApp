
const String materialAppTitle = "WeatherApp";
const int hoursToDisplay = 6;
const int daysToDisplay = 6;
const double textShimmerBorderRadius = 16;

List<Map<String, dynamic>> units = [
  {
    "key": "K",
    "name": "Kelvin", 
    "apiTemperatureUnit": "standard", 
    "symbole": "K°"
  },
  {
    "key": "C",
    "name": "Celsius", 
    "apiTemperatureUnit": "metric", 
    "symbole": "C°"
  },
  {
    "key": "F",
    "name": "Fahrenheit", 
    "apiTemperatureUnit": "imperial", 
    "symbole": "F°"
  },
];