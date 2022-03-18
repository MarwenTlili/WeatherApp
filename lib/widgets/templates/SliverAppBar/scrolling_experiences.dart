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
      delegate: SliverChildListDelegate(
        items
      )
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
List<Widget> items = [
  Card(
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
                child: Image.network( "https://picsum.photos/200/200", fit: BoxFit.cover),
              ),
              
              Center(child: Text( "X"))
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("title"),
                Text( "subtitle" )
              ],
            ),
          )
        ),
      ],
    )
  ),

  Card(
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
                child: Image.network( "https://picsum.photos/200/200", fit: BoxFit.cover),
              ),
              
              Center(child: Text( "X"))
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("title"),
                Text( "subtitle" )
              ],
            ),
          )
        ),
      ],
    )
  ),

  Card(
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
                child: Image.network( "https://picsum.photos/200/200", fit: BoxFit.cover),
              ),
              
              Center(child: Text( "X"))
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("title"),
                Text( "subtitle" )
              ],
            ),
          )
        ),
      ],
    )
  ),
  Card(
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
                child: Image.network( "https://picsum.photos/200/200", fit: BoxFit.cover),
              ),
              
              Center(child: Text( "X"))
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("title"),
                Text( "subtitle" )
              ],
            ),
          )
        ),
      ],
    )
  ),
  
  
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