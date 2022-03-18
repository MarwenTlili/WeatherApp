import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weatherapp/globals.dart';

class LocationWidget extends StatefulWidget{
  const LocationWidget({
    Key? key, 
    required this.place, 
    required this.isLoading
  }) : super(key: key);

  final Placemark? place;
  final bool isLoading;

  @override
  State<StatefulWidget> createState() => LocationWidgetState();
}

class LocationWidgetState extends State<LocationWidget>{

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon( Icons.location_on ),
        _shimmerLocation(context)
      ],
    );
  }

  Widget _shimmerLocation(BuildContext context){
    if(widget.isLoading){
      return Container(
        width: 150,
        height: 10,
        decoration: BoxDecoration(
          color: const Color.fromARGB(250, 230, 230, 230),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(textShimmerBorderRadius),
        ),
      );
    }
    return Text(
      (widget.place!.locality.toString()+", "+ widget.place!.country.toString()),
      style: const TextStyle(
        fontSize: 18.0,
        color: Color.fromARGB(255, 68, 68, 68)
      ),
    );
  }
  
}
