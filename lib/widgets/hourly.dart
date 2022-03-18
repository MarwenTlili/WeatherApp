import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/globals.dart';

class Hourly extends StatefulWidget{
  const Hourly({
    Key? key, 
    required this.isLoading,
    required this.data, 
    required this.units, 
    required this.selectedUnit,
    
  }) : super(key: key);

  final Map<String, dynamic> data ;
  final List<Map<String, dynamic>> units ;
  final String selectedUnit;
  final bool isLoading;

  @override
  State<StatefulWidget> createState() => HourlyState();
}

class HourlyState extends State<Hourly>{
  List<Widget> hours = [];
  
  @override
  Widget build(BuildContext context) {
    return _shimmerHourly();
  }

  String _customHourFormat(int timestamp){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      timestamp* 1000
    );
    String formattedDateTime = DateFormat.j().format(dateTime);
    return formattedDateTime;
  }

  Widget _shimmerHour(int index){
    if(widget.isLoading){
      return Column(
        children: <Widget>[
          Container(
            width: 40,
            height: 10,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(250, 230, 230, 230),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(textShimmerBorderRadius),
            ),
          ),
          Container(
            width: 30,
            height: 40,
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color.fromARGB(250, 230, 230, 230),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 40,
            height: 10,
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(250, 230, 230, 230),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(textShimmerBorderRadius),
            ),
          ),
        ],
      );
    }else{
      return Column(
        children: <Widget>[
          Text(
            _customHourFormat(widget.data['hourly'][index]['dt'])
          ),
          Image.network(
            "http://openweathermap.org/img/wn/${widget.data['hourly'][index]['weather'][0]['icon']}@2x.png",
            width: 50,
            height: 60,
          ),
          Text(
            widget.data['hourly'][index]['temp'].round().toString()
            +widget.units.firstWhere(
              (element) => element["key"] == widget.selectedUnit
            )["symbole"]
          ),
        ],
      );
    }
  }

  Widget _shimmerHourly(){
    hours.clear();
    for (int index = 0; index < hoursToDisplay; index++) {
      hours.add(
        _shimmerHour(index)
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top:30, ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: hours,
      ),
    );
  }

}
