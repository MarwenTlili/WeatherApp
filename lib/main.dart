import 'dart:developer' as developer;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weatherapp/widgets/home_page_content.dart';

import 'custom_scroll_behavior.dart';
import 'globals.dart';

Future main() async{
  // load api_kei from .env file
  await dotenv.load(fileName: "assets/.env");
  if(dotenv.env.containsKey("API_KEY_openweathermap")){
    developer.log("API_KEY_openweathermap load: DONE.");
  }else{
    developer.log("missing .env key: API_KEY_openweathermap !");
  }

  // running our app
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: CustomScrollBehavior(),
      title: materialAppTitle,
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
  
  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void _updateUnit(newSelectedUnit){
    setState(() {
      selectedUnit = newSelectedUnit;
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
                  onChanged: (newSelectedUnit){
                    _updateUnit(newSelectedUnit);
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
                  onChanged: (newSelectedUnit){
                    _updateUnit(newSelectedUnit);
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
                  onChanged: (newSelectedUnit){
                    _updateUnit(newSelectedUnit);
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
      body: HomePageContent(
        selectedUnit: selectedUnit, 
        data: data,
        isLoading: isLoading,
        place: place,
      ),
    );
  }

  Future<PermissionStatus> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status;
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

  Future <Map<String, dynamic>> fetchResponseFromApi(String uri) async{
    final response = await http.get(Uri.parse(uri));
    Map<String, dynamic> jsonObjectResponse = json.decode(response.body);
    return jsonObjectResponse;
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

        // openweathermap temperature unit are using 'standard', 'metric' and 'imperial'
        // so let's find those namings using the selectedUnit key
        String apiTemperatureUnit = units.firstWhere(
          (element) => element["key"] == selectedUnit
        )["apiTemperatureUnit"];

        // set url to fetch
        String onecallURL = "https://api.openweathermap.org/data/2.5/onecall?lat=${position.latitude}&lon=${position.longitude}&units=$apiTemperatureUnit&appid=${dotenv.env['API_KEY_openweathermap']}";
        
        // get weather data from OpenWeatherMap API
        fetchResponseFromApi(onecallURL).then((value){
          setState(() {
            data = value;
            isLoading = false;
          });
        }).onError((error, stackTrace){
          developer.log(error.toString());
          isLoading = false;
        });

      }).onError((error, stackTrace){
        developer.log(error.toString());
        isLoading = false;
      });

    }).onError((error, stackTrace){
      developer.log(error.toString());
      isLoading = false;
    });
  }

}
