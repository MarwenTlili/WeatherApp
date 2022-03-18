import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/globals.dart';

class Daily extends StatefulWidget{
  const Daily({
    Key? key,
    required this.isLoading,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data ;
  final bool isLoading;
  
  @override
  State<StatefulWidget> createState() => DailyState();

}

class DailyState extends State<Daily>{
  List<Widget> daysWidgets = [];

  @override
  Widget build(BuildContext context) {
    return _shimmerDaily();
  }

  Widget _shimmerDay(int index){
    if(widget.isLoading){
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 30,
              height: 10,
              margin: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(250, 230, 230, 230),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(textShimmerBorderRadius),
              ),
            ),
            Container(
              width: 70,
              height: 40,
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color.fromARGB(250, 230, 230, 230),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 100,
              height: 10,
              decoration: BoxDecoration(
                color: const Color.fromARGB(250, 230, 230, 230),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(textShimmerBorderRadius),
              ),
            ),
            Container(
              width: 50,
              height: 10,
              decoration: BoxDecoration(
                color: const Color.fromARGB(250, 230, 230, 230),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(textShimmerBorderRadius),
              ),
            )
          ],
      );
    }else{
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: 30,
              child: Text(
                _customDayFormat(widget.data['daily'][index]['dt'])
              ),
            ),
            SizedBox(
              width: 70,
              child: Image.network(
                "http://openweathermap.org/img/wn/${widget.data['daily'][index]['weather'][0]['icon']}@2x.png",
                width: 60,
                height: 60,
              ),
            ),
            SizedBox(
              child: Text(widget.data['daily'][index]['weather'][0]['description']),
              width: 100,
            ),
            SizedBox(
              child: Text("${widget.data['daily'][index]['temp']['min'].round()}..${widget.data['daily'][index]['temp']['max'].round()}"),
              width: 50,
            )
          ],
      );
    }
  }

  Widget _shimmerDaily(){
    daysWidgets.clear();
    for (var index = 0; index < daysToDisplay; index++) {
      daysWidgets.add(_shimmerDay(index));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
      child: Column(
        children: daysWidgets,
      ),
    );

  }

  String _customDayFormat(int timestamp){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      timestamp* 1000
    );
    String formattedDateTime = DateFormat.E().format(dateTime);
    return formattedDateTime;
  }

}
