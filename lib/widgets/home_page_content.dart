import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

import 'package:weatherapp/widgets/main_temperature.dart';

import '../globals.dart';

class HomePageContent extends StatefulWidget {
  final List<Map<String, dynamic>> units;
  final String selectedUnit;

  const HomePageContent({
    Key? key,
    required final this.units, required this.selectedUnit
  }) : super(key: key);
  
  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  bool isLoading = true;
  Placemark? place;
  Map<String, dynamic> data = {};
  String unit = "metric";

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  Future<void> refreshData() async{
    isLoading = true;
    // get position coordination from the Future
    _determinePosition().then((position){
      // developer.log("_determinePosition : $position");
      // get placemarks from GeoCoding.dart
      placemarkFromCoordinates(position.latitude, position.longitude).then((placemarks){
        Placemark newPlace = placemarks[0];
        // developer.log("place: ${newPlace.locality}");
        setState(() {
          place = newPlace;
        });

        // set API url
        String apiTemperatureUnit = widget.units.firstWhere(
          (element) => element["key"] == widget.selectedUnit
        )["apiTemperatureUnit"];
        var onecallURL = "https://api.openweathermap.org/data/2.5/onecall?+lat=${position.latitude}&lon=${position.longitude}&units=$apiTemperatureUnit&appid=${dotenv.env['API_KEY_openweathermap']}";
        // get weather info from OpenWeatherMap API
        fetchOpenWeatherMap(onecallURL)
        .then((value){
          setState(() {
            data = value;
            isLoading = false;
            // developer.log("isLoading: $isLoading");
          });
        }).onError((error, stackTrace){});

      }).onError((error, stackTrace){
        // developer.log("$error");
        // developer.log("$stackTrace");
      });

    }).onError((error, stackTrace){
      // developer.log("_determinePosition Error:\n $error");
      // developer.log("_determinePosition stackTrace:\n $stackTrace");
    });
  }

  @override
  Widget build(BuildContext context) {
    // Map<String, dynamic> x;
    // if(widget.units.isNotEmpty) {
    //   x = widget.units.firstWhere((element) => element["key"] == "F");
    //   developer.log(x.toString());
    // }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          expandedHeight: 200.0,
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
              child: Image.asset(
                "assets/images/weather/clear_sky.jpg", 
                fit: BoxFit.cover
              ),
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
                  MainTemperature(data: data, units: widget.units, selectedUnit: widget.selectedUnit, isLoading: isLoading),
                  // CurrentDayMinMax(data: data, units: units, unit: unit, isLoading: isLoading),
                  // Hourly(data: data, units: units, unit: unit, isLoading: isLoading),
                  // Daily(data: data,isLoading: isLoading),
                  // CurrentWeatherDetails(data: data, units: units, unit: unit, isLoading: isLoading),
                ],
              ),
            )
            
          ])
        )
      ],
    );
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

    // developer.log("serviceEnabled: $serviceEnabled");

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
}