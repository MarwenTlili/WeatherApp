
const String TITLE = "WeatherApp";
const String HOME_PAGE_TITLE = "Weather App";

const double pageAllPadding = 10;
const int rightPadding = 10;
const double leftPadding = 10;

const double locationTopPadding = 10;
const int currentTemperatureBottomPadding = 50;
const int hourlyTemperatureBottomPadding = 50;
const int dailyTemperatureBottomPadding = 50;

String unitDefault = "metric";


// String weather_url = "api.openweathermap.org/data/2.5/weather?lat=[lat]&lon=[lon]&appid=[API key][&units={standard,metric,imperial}]";
String onecall_url = "api.openweathermap.org/data/2.5/onecall?lat=0&lon=0&appid=";

const int hoursToDisplay = 6;
String iconId = "";
String iconsUrl = "http://openweathermap.org/img/wn/$iconId@2x.png";

const int daysToDisplay = 6;
const double textShimmerBorderRadius = 16;

// class MainTemperatureState extends State<MainTemperature>{
//   @override
//   Widget build(BuildContext context) {
//     return _shimmerLocation(context);
//   }
//   Widget _shimmerLocation(BuildContext context){
//     if(widget.isLoading == true){
//       return Padding(
//         padding: const EdgeInsets.only(
//           top: 100,
//           left: 10,
//           bottom: 10
//         ),
//         child: Row(
//           children: <Widget>[
//             Container(
//               width: 50,
//               height: 50,
//               decoration: const BoxDecoration(
//                 color: Color.fromARGB(250, 230, 230, 230),
//                 shape: BoxShape.rectangle,
//               )
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 10),
//                 child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Container(
//                     width: 50,
//                     height: 10,
//                     decoration: const BoxDecoration(
//                       color: Color.fromARGB(250, 230, 230, 230),
//                       shape: BoxShape.rectangle,
//                     )
//                   ),
//                   Container(
//                     width: 100,
//                     height: 10,
//                     decoration: const BoxDecoration(
//                       color: Color.fromARGB(250, 230, 230, 230),
//                       shape: BoxShape.rectangle,
//                     )
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     }else{
//       return Padding(
//         padding: const EdgeInsets.only(
//           top: 100,
//           left: 10,
//           bottom: 10
//         ),
//         child: Row(
//           children: <Widget>[
//             Text(
//               !widget.data.containsKey("current") 
//               ? "0" 
//               : widget.data["current"]["temp"].round().toString(),
//               style: const TextStyle(fontSize: 52)
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 10),
//                 child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     widget.units[widget.unit], 
//                     style: const TextStyle(fontSize: 18)
//                   ),
//                   Text(
//                     !widget.data.containsKey("current")
//                     ? "..." 
//                     : widget.data["current"]["weather"][0]["description"]
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }