import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../globals.dart';

class CurrentDayMinMax extends StatefulWidget{
  const CurrentDayMinMax({
    Key? key, 
    required this.data, 
    required this.selectedUnit,
    required this.isLoading
  }) : super(key: key);

  final Map<String, dynamic> data ;
  final String selectedUnit;
  final bool isLoading;

  @override
  State<StatefulWidget> createState() => CurrentDayMinMaxState();
}

class CurrentDayMinMaxState extends State<CurrentDayMinMax>{
  @override
  Widget build(BuildContext context) {
    return _shimmerCurrentDayMinMax(context);
  }

  Widget _shimmerCurrentDayMinMax(BuildContext context){
    if(widget.isLoading == true){
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: <Widget>[
            Container(
                width: 200,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(250, 230, 230, 230),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(textShimmerBorderRadius),
                ),
            ),
          ],
        ),
      );
    }else{
      return Row(
        children: <Widget>[
          Text(_customDateFormat( widget.data["current"]["dt"])),
          const SizedBox(width: 20),
          Text(
            widget.data["daily"][0]["temp"]["min"].round().toString()
            +units.firstWhere(
              (element) => element["key"] == widget.selectedUnit
            )["symbole"]+".."
          ),
          Text(
            widget.data["daily"][0]["temp"]["max"].round().toString()
            +units.firstWhere(
              (element) => element["key"] == widget.selectedUnit
            )["symbole"]
          )
        ]
      );
    }
  }

  String _customDateFormat(int timestamp){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      timestamp* 1000
    );
    String formattedDateTime = DateFormat.MMMMEEEEd().format(dateTime);
    return formattedDateTime;
  }
}