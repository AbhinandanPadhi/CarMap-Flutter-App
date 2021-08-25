import 'package:flutter/material.dart';
import 'paramaters_controller.dart';
import 'main_controller.dart';
import 'parking_lot_manager.dart';
import 'car_park_map_view.dart';
import 'car_park_list_view.dart';
import 'navigation_controller.dart';
import 'parking_lot.dart';

class DisplayCarParks extends StatefulWidget {
  _DisplayCarParksState createState() => _DisplayCarParksState();
}

class _DisplayCarParksState extends State<DisplayCarParks>
    with SingleTickerProviderStateMixin
    implements Observer {
  var viewType = 0;

  void changeView(int type) {
    this.setState(() {
      this.viewType = viewTypeController.switchView(type);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void update() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blueGrey[500],
          centerTitle: true,
          title: Text(
            'CarMap',
            style: TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 30,
              color: Colors.white,
            ),
          )),
      body: Container(
          color: Colors.blueGrey[900],
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                child: Center(
                  child: Text(
                      'Use the slider below to adjust search radius (0 to 5 km):',
                      style: TextStyle(
                          fontFamily: 'Source Sans Pro',
                          fontSize: 20,
                          color: Colors.white)),
                ),
              ),
              Container(
                child: SearchRadiusSlider(
                    updateSearchRadius:
                        SearchRadiusController.updateSearchRadius),
                margin: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("0 km",
                          style: TextStyle(
                            fontFamily: 'Source Sans Pro',
                            fontSize: 16,
                            color: Colors.white,
                          )),
                      Text("5 km",
                          style: TextStyle(
                            fontFamily: 'Source Sans Pro',
                            fontSize: 16,
                            color: Colors.white,
                          )),
                    ],
                  )),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text("Choose view:",
                          style: TextStyle(
                            fontFamily: 'Source Sans Pro',
                            fontSize: 20,
                            color: Colors.white,
                          )),
                      CarParkListViewButton(
                        changeView: this.changeView,
                      ),
                      CarParkMapViewButton(
                        changeView: this.changeView,
                      )
                    ]),
              ),
              (viewType == 0 ? CarParkListView() : MapView()),
            ]),
          )),
    );
  }
}

class SearchRadiusSlider extends StatefulWidget {
  final void Function(int range) updateSearchRadius;

  const SearchRadiusSlider({this.updateSearchRadius});

  @override
  _SearchRadiusSliderState createState() => _SearchRadiusSliderState();
}

class _SearchRadiusSliderState extends State<SearchRadiusSlider> {
  RangeValues range = new RangeValues(0, 5);
  RangeLabels labels = new RangeLabels('0', '5');

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      activeColor: Colors.blue[700],
      inactiveColor: Colors.white,
      min: 0,
      max: 5,
      divisions: 5,
      values: range,
      labels: labels,
      onChanged: (val) {
        widget.updateSearchRadius(val.end.toInt());
        setState(() {
          range = new RangeValues(0, val.end);
          labels = RangeLabels(range.start.toString(), range.end.toString());
        });
      },
    );
  }
}

class CarParkListViewButton extends StatefulWidget {
  final void Function(int type) changeView;

  const CarParkListViewButton({this.changeView});

  @override
  _CarParkListViewButtonState createState() => _CarParkListViewButtonState();
}

class _CarParkListViewButtonState extends State<CarParkListViewButton> {
  bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "List",
            style: new TextStyle(
              fontFamily: 'Source Sans Pro',
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        color: Colors.blue[300],
        onPressed: () {
          widget.changeView(0);
        },
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10),
          side: new BorderSide(color: Colors.white, width: 1),
        ),
      ),
    );
  }
}

class CarParkMapViewButton extends StatefulWidget {
  final void Function(int type) changeView;

  const CarParkMapViewButton({this.changeView});

  @override
  _CarParkMapViewButtonState createState() => _CarParkMapViewButtonState();
}

class _CarParkMapViewButtonState extends State<CarParkMapViewButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Map",
            style: new TextStyle(
              fontFamily: 'Source Sans Pro',
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        color: Colors.teal[200],
        onPressed: () {
          widget.changeView(1);
        },
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10),
          side: new BorderSide(color: Colors.white, width: 1),
        ),
      ),
    );
  }
}

class CarParkInfo extends StatefulWidget {
  @override
  _CarParkInfoState createState() => _CarParkInfoState();
}

class _CarParkInfoState extends State<CarParkInfo> implements Observer {
  Color borderColor;
  CarPark carPark;

  void update() {
    this.carPark = ParkingLotManager.getData()[1];
  }

  void navigate() {
    NavigationController.navigate(
        this.carPark.latitude, this.carPark.longitude);
  }

  @override
  void initState() {
    var data = ParkingLotManager.getData();
    this.carPark = data[1];

    if (this.carPark.availability < 0.4) {
      this.borderColor = Colors.teal[300];
    } else if (0.4 <= this.carPark.availability &&
        this.carPark.availability <= 0.8) {
      this.borderColor = Colors.orange[300];
    } else {
      this.borderColor = Colors.redAccent;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey[700],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: new BorderSide(color: this.borderColor, width: 2),
      ),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.trip_origin,
                color: Colors.white,
                size: 24,
              ),
              Padding(padding: EdgeInsets.only(left: 24)),
              Text(
                this.carPark.parkID,
                style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 25.0)),
          Text(
            this.carPark.address,
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white),
            textAlign: TextAlign.center,
          ),
          Padding(padding: EdgeInsets.only(top: 25.0)),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.directions,
                color: Colors.white,
                size: 20.0,
              ),
              Padding(padding: EdgeInsets.only(left: 10)),
              Text(
                "${this.carPark.distance} km from destination",
                style: new TextStyle(fontSize: 18.0, color: Colors.white),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.directions_car,
                color: Colors.white,
                size: 20.0,
              ),
              Padding(padding: EdgeInsets.only(left: 10)),
              Text(
                "${this.carPark.countAvailable} lots available",
                style: new TextStyle(fontSize: 18.0, color: this.borderColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Center(
              child: RaisedButton(
                color: this.borderColor,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.map,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      "Navigate",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () {
                  this.navigate();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
