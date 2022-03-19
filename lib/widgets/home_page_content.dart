import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:developer' as developer;
import 'package:weatherapp/widgets/current_day_min_max.dart';
import 'package:weatherapp/widgets/current_weather_details.dart';
import 'package:weatherapp/widgets/daily.dart';
import 'package:weatherapp/widgets/hourly.dart';

import 'package:weatherapp/widgets/main_temperature.dart';

import '../globals.dart';

class HomePageContent extends StatefulWidget {
  final String selectedUnit;
  final Map<String, dynamic> data;
  final bool isLoading;
  final Placemark? place;

  const HomePageContent({
    Key? key,
    required this.selectedUnit, 
    required this.data, 
    required this.isLoading, 
    this.place
  }) : super(key: key);
  
  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
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
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
      developer.log("HomePageContent -> data: loaded.");
    }else{
      developer.log("HomePageContent -> data: empty!");
    }
    return SafeArea(
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
                  )
                ),
                child: widget.data.isEmpty
                  ? Image.asset(
                    "assets/images/weather/clear_sky.jpg", 
                    fit: BoxFit.cover
                  )
                  : backgroundImages.firstWhere(
                    (element){
                      return element["description"] == widget.data["current"]["weather"][0]["description"];
                    }
                  )["image"],
              ),
            ),
          ),
          
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    MainTemperature(data: widget.data, selectedUnit: widget.selectedUnit, isLoading: widget.isLoading),
                    CurrentDayMinMax(data: widget.data, selectedUnit: widget.selectedUnit, isLoading: widget.isLoading),
                    Hourly(data: widget.data, selectedUnit: widget.selectedUnit, isLoading: widget.isLoading),
                    Daily(data: widget.data,isLoading: widget.isLoading),
                    CurrentWeatherDetails(data: widget.data, isLoading: widget.isLoading),
                  ],
                ),
              )
            ])  
          )
        ],
      )
    );
  }

  Widget _shimmerLocation(BuildContext context){
    if(widget.isLoading){
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
        const Icon(Icons.location_on_outlined),
        Text(
          (widget.place!.locality.toString()+", "+ widget.place!.country.toString()),
          style: const TextStyle(
            fontSize: 18.0,
            color: Color.fromARGB(255, 68, 68, 68)
          ),
        )
      ],
    );
  }

}