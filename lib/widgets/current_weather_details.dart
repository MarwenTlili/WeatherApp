import 'package:flutter/material.dart';

import '../globals.dart';

class CurrentWeatherDetails extends StatefulWidget{
  const CurrentWeatherDetails({
    Key? key,
    required this.isLoading,
    required this.data,
    required this.units,
    required this.unit
  }) : super(key: key);

  final bool isLoading;
  final Map<String, dynamic> data;
  final List<Map<String, dynamic>> units;
  final String unit;

  @override
  State<StatefulWidget> createState() => CurrentWeatherDetailsState();
}

class CurrentWeatherDetailsState extends State<CurrentWeatherDetails>{
  TextStyle titlesStyle = const TextStyle(color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: leftPadding),
            child: Text(
              "Weather Details", 
              style: TextStyle(
                fontWeight: FontWeight.bold
              )
            ),
          ),

          _shimmerDetails(context),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text("Powered by MarwenTlili"),
            ],
          )
        ],
      ),
    );
  }

  Widget _shimmerDetails(BuildContext context){
    if(widget.isLoading){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: <Widget>[
                    Text("Apparent Temperature", style: titlesStyle),
                    Container(
                      width: 40,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(250, 230, 230, 230),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(textShimmerBorderRadius),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: <Widget>[
                    Text("Wind Speed", style: titlesStyle),
                    Container(
                      width: 40,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(250, 230, 230, 230),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(textShimmerBorderRadius),
                      ),
                    ),
                  ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: <Widget>[
                    Text("Visibility", style: titlesStyle),
                    Container(
                      width: 40,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(250, 230, 230, 230),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(textShimmerBorderRadius),
                      ),
                    ),
                  ]
                )
              )
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: <Widget>[
                    Text("Humidity", style: titlesStyle),
                    Container(
                      width: 40,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(250, 230, 230, 230),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(textShimmerBorderRadius),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: <Widget>[
                    Text("UV", style: titlesStyle),
                    Container(
                      width: 40,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(250, 230, 230, 230),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(textShimmerBorderRadius),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: <Widget>[
                    Text("Air Pressure", style: titlesStyle),
                    Container(
                      width: 60,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(250, 230, 230, 230),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(textShimmerBorderRadius),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: <Widget>[
                  Text("Apparent Temperature", style: titlesStyle),
                  Text(widget.data["current"]["temp"].round().toString()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: <Widget>[
                  Text("Wind Speed", style: titlesStyle),
                  Text(widget.data["current"]["wind_speed"].round().toString()+" metre/sec"),
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: <Widget>[
                  Text("Visibility", style: titlesStyle),
                  Text((widget.data["current"]["visibility"]/1000).round().toString()+" km/h"),
                ]
              )
            )
          ],
        ),
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: <Widget>[
                  Text("Humidity", style: titlesStyle),
                  Text(widget.data["current"]["humidity"].toString()+" %"),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: <Widget>[
                  Text("UVI", style: titlesStyle),
                  Text(widget.data["current"]["uvi"].toString()),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: <Widget>[
                  Text("Air Pressure", style: titlesStyle),
                  Text(widget.data["current"]["humidity"].toString()+" hpa"),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  
}