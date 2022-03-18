import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:developer' as developer;

void main(List<String> args) => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              // pinned: true,
              // snap: true,
              // floating: true,
              expandedHeight: 200.0,
              stretch: true,
              onStretchTrigger: () async{
                developer.log("");
              },
              flexibleSpace: FlexibleSpaceBar(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const <Widget>[
                    Center(
                      child: Text("Title"),
                    )
                  ]
                ),
                background: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration:  const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: <Color>[
                        Colors.orangeAccent,
                        Colors.transparent
                      ]
                    )
                  ),
                  child: Image.network( 
                    "https://picsum.photos/200/300", 
                    fit: BoxFit.cover
                  ),
                ),
                stretchModes: const <StretchMode>[
                  StretchMode.blurBackground,
                  StretchMode.fadeTitle,
                  StretchMode.zoomBackground
                ],
              ),
            ),
            const CustomWidget()
          ]
        ),
      )
    );
  }
  
}

class CustomWidget extends StatefulWidget {
  const CustomWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CustomWidgetState();
  
}

class CustomWidgetState extends State<CustomWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index){
          Map<String, dynamic> item = items[index];
          return Card(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 200.0,
                  height: 200.0,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      DecoratedBox(
                        position: DecorationPosition.foreground,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            radius: 0.3,
                            colors: <Color>[
                              Colors.grey[800]!,
                              Colors.transparent
                            ]
                          )
                        ),
                        child: Image.network( "https://picsum.photos/200/20$index", fit: BoxFit.cover),
                      ),
                      
                      Center(child: Text( "${index+1}"))
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text( item["title"] ),
                        Text( item["subtitle"] )
                      ],
                    ),
                  )
                ),
              ],
            )
          );
        },
        childCount: items.length
      )
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
List<Map<String, dynamic>> items = [
  {
    "leading": "leading 1",
    "title": "leading 1",
    "subtitle": "subtitle 1",
  },
  {
    "leading": "leading 2",
    "title": "leading 2",
    "subtitle": "subtitle 2",
  },
  {
    "leading": "leading 3",
    "title": "leading 3",
    "subtitle": "subtitle 3",
  },
  {
    "leading": "leading 4",
    "title": "leading 4",
    "subtitle": "subtitle 4",
  },
  {
    "leading": "leading 5",
    "title": "leading 5",
    "subtitle": "subtitle 5",
  },
  {
    "leading": "leading 6",
    "title": "leading 6",
    "subtitle": "subtitle 6",
  },
  {
    "leading": "leading 7",
    "title": "leading 7",
    "subtitle": "subtitle 7",
  },
  {
    "leading": "leading 8",
    "title": "leading 8",
    "subtitle": "subtitle 8",
  },
  {
    "leading": "leading 9",
    "title": "leading 9",
    "subtitle": "subtitle 9",
  },
  {
    "leading": "leading 10",
    "title": "leading 10",
    "subtitle": "subtitle 10",
  },
  
];

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => { 
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

// ListTile(
//   leading: Text(card["leading"]),
//   title: Text(card["title"]),
//   subtitle: Text(card["subtitle"]),
// )