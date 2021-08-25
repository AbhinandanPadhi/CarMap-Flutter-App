import 'package:flutter/material.dart';
import 'search_controller.dart';
import 'main_controller.dart';
import 'destination.dart';
import 'destination_manager.dart';
import 'display_car_parks_view.dart';

/// Please note that a so-called "Stateful Widget" in Flutter allows the emulator
/// to display changes in the state of the app, such as when a user enters
/// his or her target destination address or keywords from the address
/// into CarMap's search bar. It also applies to buttons and other dynamic
/// UI elements.

class DestinationSearchView extends StatefulWidget {
  @override
  _DestinationSearchViewState createState() => _DestinationSearchViewState();
}

/// The following class is generated when a Stateful Widget is created:

class _DestinationSearchViewState extends State<DestinationSearchView>
    implements Observer {
  _DestinationSearchViewState() {}

  /// Explicitly Initializing the Destination to be NULL at the beginning
  /// in case data from a previous session is stored:

  Destination selectedDestination = null;
  List<Destination> destinations = [];

  SearchForDestinationController searchDestinationController =
      new SearchForDestinationController();

  void update() {
    List data = DestinationManager.getData();
    this.setState(() {
      this.selectedDestination = data[1];
      this.destinations = data[0];
    });
  }

  /// Please note that "AboutApp" refers to the pop-up window that
  /// displays information about our app, CarMap, such as who created it
  /// and what it does and which APIs it uses

  AboutAppPopUp(BuildContext context) =>
      AboutAppController.AboutAppPopUp(context);

  enterDestination(String text) =>
      searchDestinationController.enterDestinationControl(text);

  selectDestination(Destination selectedDestination) {
    this.selectedDestination = selectedDestination;
    searchDestinationController.selectDestinationControl(selectedDestination);
  }

  @override
  void initState() {
    super.initState();
    DestinationManager.attach(this);
  }

  /// The following is the dart code for the User Interface (UI) design of
  /// the start-up screen (destination search view).
  /// In Flutter, the UI design generally starts with the Scaffold.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        /// Safe Area used to ensure the UI doesn't display in areas such as
        /// iPhone or other phone "notches".
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: SingleChildScrollView(
            /// To enable the app to be scrollable so that there is no
            /// overflow at bottom of screen.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Align(
                    child: AboutApp(
                      /// To display information about our app
                      AboutAppPopUp: () {
                        this.AboutAppPopUp(context);
                      },
                    ),
                    alignment: Alignment.topRight,
                  ),
                ),
                Text('CarMap',
                    style: TextStyle(
                      fontFamily: 'Pacifico',

                      /// A fancy, external font has been used to make the app look great!
                      fontSize: 80.0,
                      color: Colors.white,
                    )),
                CircleAvatar(
                  /// A custom logo has been used that we created!
                  radius: 100,
                  backgroundImage: AssetImage('assets/app_logo.png'),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Row(
                    children: <Widget>[
                      SearchBar(
                        /// This is the search bar.
                        enterDestination: enterDestination,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      OkButton(
                        /// This is the "OK" button that is displayed on the screen.
                        active: this.selectedDestination == null ? false : true,
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 10),
                    child: Container(
                      height: 250.0,
                      width: 300.0,
                      child: DropDownList(
                        /// This is a dynamic drop down list whose contents change
                        /// based on the data retrieved from Google Maps API.
                        /// It displays the closest matches to the keywords
                        /// entered by the user first.
                        selectDestination: this.selectDestination,
                        destinations: this.destinations,
                        selectedDestination: this.selectedDestination,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final void Function(String text) enterDestination;

  const SearchBar({this.enterDestination});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
        child: TextField(
          onChanged: (value) {
            widget.enterDestination(value);
          },
          decoration: InputDecoration(
            hintText: "Enter Destination Here",
            prefixIcon: Icon(
              Icons.search,
              color: Colors.blue[600],
              size: 28,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
      ),
    );
  }
}

class DropDownList extends StatefulWidget {
  final Function selectDestination;
  final List<Destination> destinations;
  final Destination selectedDestination;

  const DropDownList(
      {this.selectDestination, this.destinations, this.selectedDestination});

  @override
  _DropDownListState createState() => _DropDownListState();
}

class _DropDownListState extends State<DropDownList> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        padding: EdgeInsets.only(top: 2.0),
        shrinkWrap: true,
        itemBuilder: (_, int index) {
          return GestureDetector(
            onTap: () {
              widget.selectDestination(widget.destinations[index]);
            },
            child: Card(
                color: (widget.selectedDestination != null &&
                        widget.selectedDestination.addressName ==
                            widget.destinations[index].addressName)
                    ? Colors.lightBlueAccent
                    : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 2.0, bottom: 2.0, left: 10.0, right: 5.0),
                  child: Text(
                    widget.destinations[index].addressName,
                    style: new TextStyle(fontSize: 20.0),
                  ),
                ),
                elevation: 1.5),
          );
        },
        itemCount: widget.destinations == null ? 0 : widget.destinations.length,
      ),
    );
  }
}

class AboutAppController {
  static void AboutAppPopUp(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AboutAppView();
        });
  }
}

class AboutAppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: Text(
        "What is CarMap?",
        style: new TextStyle(color: Colors.blueGrey, fontSize: 24),
        textAlign: TextAlign.center,
      ),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "CarMap is a Flutter app that has been developed by a group of (really smart) students from NTU - group 'RunTime Terror' - for CZ2006 Software Engineering.",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 20),
          Text(
            "Our app uses the government API for parking lots in Singapore and the ever-so-popular Google Maps API.",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 20),
          Text(
            "CarMap will find for you the car parks nearest to a specified destination or car parks sorted by number of available parking lots (within some radius of the destination).",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 20),
          Text(
            "CarMap v1.0 - RunTime Terror, CZ2006, SS2",
            style: TextStyle(fontSize: 14, color: Colors.blue[800]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class AboutApp extends StatefulWidget {
  final Function AboutAppPopUp;
  const AboutApp({this.AboutAppPopUp});

  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: new Icon(Icons.help_outline),
      iconSize: 40.0,
      color: Colors.grey,
      onPressed: () => widget.AboutAppPopUp(),
    );
  }
}

class OkButton extends StatefulWidget {
  final bool active;
  const OkButton({this.active});

  @override
  _OkButtonState createState() => _OkButtonState();
}

class _OkButtonState extends State<OkButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        child: Text(
          'OK',
          style: TextStyle(
            fontFamily: 'Source Sans Pro',
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        color: Colors.blue[500],
        onPressed: () {
          if (widget.active) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DisplayCarParks()),
            );
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(15.0),
        ),
      ),
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      height: 60,
    );
  }
}
