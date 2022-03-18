import 'package:flutter/material.dart';

import '../globals.dart';

class MainTemperature extends StatefulWidget{
  const MainTemperature({
    Key? key, 
    required this.data, 
    required this.units, 
    required this.selectedUnit,
    required this.isLoading
  }) : super(key: key);

  final Map<String, dynamic> data ;
  final List<Map<String, dynamic>> units ;
  final String selectedUnit;
  final bool isLoading;

  @override
  State<StatefulWidget> createState() => MainTemperatureState();
}

class MainTemperatureState extends State<MainTemperature>{
  @override
  Widget build(BuildContext context) {
    return _shimmerMainTemperature(context);
  }

  Widget _shimmerMainTemperature(BuildContext context){
    if(widget.isLoading == true){
      return Row(
          children: <Widget>[
            Container(
              width: 58,
              height: 52,
              margin: const EdgeInsets.only(top: 5, right: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(250, 230, 230, 230),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(textShimmerBorderRadius),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 18,
                  height: 20,
                  margin: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(250, 230, 230, 230),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(textShimmerBorderRadius),
                  ),
                ),
                Container(
                  width: 100,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(250, 230, 230, 230),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(textShimmerBorderRadius),
                  )
                )
              ],
            ),
          ],
      );
    }else{
      return Row(
        children: <Widget>[
          Text(
            widget.data["current"]["temp"].round().toString(),
            style: const TextStyle(fontSize: 52)
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.units.firstWhere(
                  (element) => element["key"] == widget.selectedUnit
                )["symbole"], 
                style: const TextStyle(fontSize: 18)
              ),
              Text(
                widget.data["current"]["weather"][0]["description"]
              )
            ],
          ),
        ],
      );
    }
  }
}

