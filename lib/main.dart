import 'dart:developer' as developer;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weatherapp/widgets/daily.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weatherapp/widgets/hourly.dart';
import 'package:weatherapp/widgets/main_temperature.dart';

import 'custom_scroll_behavior.dart';
import 'globals.dart';

import 'widgets/current_day_min_max.dart';
import 'widgets/current_weather_details.dart';


Future main() async{
  await dotenv.load(fileName: "assets/.env");
  if(dotenv.env.containsKey("API_KEY_openweathermap")){
    developer.log("API_KEY_openweathermap load: DONE.");
  }else{
    developer.log("missing .env key: API_KEY_openweathermap !");
  }
  
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: CustomScrollBehavior(),
      title: TITLE,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedUnit = "C";
  bool isLoading = true;
  Placemark? place;
  Map<String, dynamic> data = {};
  String unit = "metric";
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
  List<Map<String, dynamic>> backgroundImages = [
    {"description": "clear sky", "image": Image.asset("assets/images/weather/clear_sky.jpg", fit: BoxFit.cover)},
    {"description": "few clouds", "image": Image.asset("assets/images/weather/few_clouds.jpg", fit: BoxFit.cover)},
    {"description": "scattered clouds", "image":  Image.asset("assets/images/weather/scattered_clouds.jpg", fit: BoxFit.cover)},
    {"description": "broken clouds", "image":  Image.asset("assets/images/weather/broken_clouds.jpg", fit: BoxFit.cover)},
    {"description": "shower rain", "image":  Image.asset("assets/images/weather/shower_rain.jpg", fit: BoxFit.cover)},
    {"description": "rain", "image":  Image.asset("assets/images/weather/rain.jpg", fit: BoxFit.cover)},
    {"description": "thunderstorm", "image":  Image.asset("assets/images/weather/thunderstorm.jpg", fit: BoxFit.cover)},
    {"description": "snow", "image":  Image.asset("assets/images/weather/snow.jpg", fit: BoxFit.cover)},
    {"description": "mist", "image":  Image.asset("assets/images/weather/mist.jpg", fit: BoxFit.cover)},
  ];

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void _updateUnit(value){
    setState(() {
      selectedUnit = value;
      refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 120.0,
              child: DrawerHeader(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text('Options', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
            ExpansionTile(
              title: const Text("Temperature Unit"),
              children: [
                RadioListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const <Widget>[
                      Text("Fahrenheit"),
                      Icon(Icons.thermostat)
                    ],
                  ),
                  value: 'F', 
                  groupValue: selectedUnit, 
                  onChanged: (value){
                    _updateUnit(value);
                  }
                ),
                RadioListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const <Widget>[
                      Text("Celsius"),
                      Icon(Icons.thermostat)
                    ],
                  ),
                  value: 'C', 
                  groupValue: selectedUnit, 
                  onChanged: (value){
                    _updateUnit(value);
                  }
                ),
                RadioListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const <Widget>[
                      Text("Kelvin"),
                      Icon(Icons.thermostat)
                    ],
                  ),
                  value: 'K', 
                  groupValue: selectedUnit, 
                  onChanged: (value){
                    _updateUnit(value);
                  }
                )
              ]
              ,
            ),
            ListTile(
              title: const Text("About"),
              onTap: (){},
            ),
            ListTile(
              title: const Text('Return'),
              onTap: (){  Navigator.pop(context); },
            ),
          ],
        ),
      ),
      // body: HomePageContent(units: units, selectedUnit: selectedUnit),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 300.0,
              stretch: false,
              onStretchTrigger: () async{
                developer.log("stretch trigered.");
              },
              flexibleSpace: FlexibleSpaceBar(
                // centerTitle: false,
                titlePadding: const EdgeInsets.only(left: 0, top: 0),
                title: _shimmerLocation(context),
                expandedTitleScale: 1.1,
                background: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration:  const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: <Color>[
                        Colors.white,
                        Color.fromARGB(127, 255, 255, 255),
                        Color.fromARGB(30, 255, 255, 255),
                        Colors.transparent
                      ],
                      // stops: [
                      //   1
                      // ]
                    )
                  ),
                  child: data.isEmpty
                    ? Image.asset(
                      "assets/images/weather/clear_sky.jpg", 
                      fit: BoxFit.cover
                    )
                    : backgroundImages.firstWhere(
                      (element){
                        return element["description"] == data["current"]["weather"][0]["description"];
                      }
                    )["image"],
                ),
              ),
            ),
            
            SliverList(
              delegate: SliverChildListDelegate([
                // LocationWidget(place: place, isLoading: isLoading),
                // const SizedBox(height: 210),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      MainTemperature(data: data, units: units, selectedUnit: selectedUnit, isLoading: isLoading),
                      CurrentDayMinMax(data: data, units: units, selectedUnit: selectedUnit, isLoading: isLoading),
                      Hourly(data: data, units: units, selectedUnit: selectedUnit, isLoading: isLoading),
                      Daily(data: data,isLoading: isLoading),
                      CurrentWeatherDetails(data: data, units: units, unit: unit, isLoading: isLoading),
                    ],
                  ),
                )
                
              ])  
            )
          ],
        )
      )
    );
  }

  /// Determine the current position of the device.
  /// using geolocator.dart
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      requestPermission(Permission.location).then((value){
        // developer.log("now location permission is granted.");
        const SnackBar(content: Text("now location permission is granted."));
        serviceEnabled = true;
      }).onError((error, stackTrace){
        const SnackBar(
          content: Text(
            "You can't use this app without location permission!\nrefresh and try again"
          ),
        );
      });
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    } 

    return await Geolocator.getCurrentPosition();
  }

  Future<PermissionStatus> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status;
  }

  Future <Map<String, dynamic>> fetchOpenWeatherMap(String uri) async{
    final response = await http.get(Uri.parse(uri));
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    setState(() {
      data = jsonResponse;
    });
    return jsonResponse;
  }

  Future<void> onRefresh() async {
    developer.log("refresh");
    await refreshData();
  }

  Future<void> refreshData() async{
    isLoading = true;
    // get position coordination from the Future
    _determinePosition().then((position){
      // get placemarks from GeoCoding.dart
      placemarkFromCoordinates(position.latitude, position.longitude).then((placemarks){
        Placemark newPlace = placemarks[0];
        setState(() {
          place = newPlace;
        });

        // set API url
        String apiTemperatureUnit = units.firstWhere(
          (element) => element["key"] == selectedUnit
        )["apiTemperatureUnit"];
        developer.log(apiTemperatureUnit);
        var onecallURL = "https://api.openweathermap.org/data/2.5/onecall?lat=${position.latitude}&lon=${position.longitude}&units=$apiTemperatureUnit&appid=${dotenv.env['API_KEY_openweathermap']}";
        developer.log(onecallURL);
        // get weather info from OpenWeatherMap API
        fetchOpenWeatherMap(onecallURL)
        .then((value){
          setState(() {
            data = value;
            isLoading = false;
          });
        }).onError((error, stackTrace){});

      }).onError((error, stackTrace){});

    }).onError((error, stackTrace){});
  }

  Widget _shimmerLocation(BuildContext context){
    if(isLoading){
      return Row(
        children: [
          const Icon( Icons.location_on_outlined ),
          Container(
            width: 150,
            height: 10,
            decoration: BoxDecoration(
              color: const Color.fromARGB(250, 230, 230, 230),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(textShimmerBorderRadius),
            ),
          )
        ],
      );
    }
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.location_on_outlined),
          onPressed: refreshData, 
        ),
        Text(
          (place!.locality.toString()+", "+ place!.country.toString()),
          style: const TextStyle(
            fontSize: 18.0,
            color: Color.fromARGB(255, 68, 68, 68)
          ),
        )
      ],
    );
  }
}
