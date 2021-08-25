import 'package:flutter/material.dart';
import 'search_view.dart';

void main() => runApp(Startup());

class Startup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CarMap",

      /// Since Emulator displays a "Debug" banner on the phone display,
      /// the line below will turn it off:
      debugShowCheckedModeBanner: false,

      /// Load the start-up screen (also called Destination Search Screen or
      /// "view" (from MVC design in lectures)) as this is where the user enters
      /// the address of the destination or keywords relating to the address:
      home: DestinationSearchView(),
    );
  }
}
