import 'paramaters_controller.dart';
import 'main_controller.dart';
import 'parking_lot_manager.dart';
import 'parking_lot.dart';
import 'package:flutter/material.dart';
import 'selection_controller.dart';

class CarParkListView extends StatefulWidget {
  @override
  _CarParkListViewState createState() => _CarParkListViewState();
}

class _CarParkListViewState extends State<CarParkListView> implements Observer {
  List<CarPark> carParkList = [];
  CarPark selectedCarPark;

  Color chooseColor(CarPark carPark) {
    if (carPark.availability < 0.4) {
      return Colors.greenAccent;
    } else if (0.4 <= carPark.availability && carPark.availability <= 0.8) {
      return Colors.orangeAccent;
    } else {
      return Colors.redAccent;
    }
  }

  @override
  void initState() {
    super.initState();
    ParkingLotManager.attach(this);
    List data = ParkingLotManager.getData();
    this.carParkList = data[0];
    this.selectedCarPark = data[1];
  }

  @override
  void dispose() {
    ParkingLotManager.detach(this);
    super.dispose();
  }

  void update() {
    //updates list of car parks displayed
    List data = ParkingLotManager.getData();
    this.setState(() {
      this.carParkList = data[0];
      this.selectedCarPark = data[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.58,
              child: new ListView.builder(
                  padding: EdgeInsets.only(top: 2.0),
                  itemCount: this.carParkList == null ? 0 : carParkList.length,
                  itemBuilder: (BuildContext context, int index) =>
                      new CarParkListItem(
                        carPark: carParkList[index],
                        borderColor: chooseColor(carParkList[index]),
                      )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Sort Parking Lots by: ',
                  style: new TextStyle(
                    fontFamily: 'Source Sans Pro',
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SortByDistanceButton(
                    orderBy: sortTypeController.switchSortType),
                SortByAvailabilityButton(
                    orderBy: sortTypeController.switchSortType),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CarParkListItem extends StatefulWidget {
  final CarPark carPark;
  final Color borderColor;

  const CarParkListItem({this.carPark, this.borderColor});

  @override
  _CarParkListItemState createState() => _CarParkListItemState();
}

class _CarParkListItemState extends State<CarParkListItem> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SelectionController.showCarParkInfo(widget.carPark, context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 14),
        child: Card(
          color: Colors.blueGrey[500],
          elevation: 5.0,
          shape: RoundedRectangleBorder(
              side: new BorderSide(color: widget.borderColor, width: 2.5),
              borderRadius: BorderRadius.circular(15.0)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    width: 180.0,
                    child: Text(
                      widget.carPark.address,
                      style: new TextStyle(
                        fontFamily: 'Source Sans Pro',
                        fontSize: 24,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    )),
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Available",
                        style: new TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        "${widget.carPark.countAvailable}",
                        style: new TextStyle(
                          fontSize: 24,
                          color: widget.borderColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Distance",
                        style: new TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        "${widget.carPark.distance} km",
                        style: new TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ],
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

class SortByDistanceButton extends StatefulWidget {
  final void Function(int type) orderBy;

  const SortByDistanceButton({this.orderBy});

  @override
  _SortByDistanceButtonState createState() => _SortByDistanceButtonState();
}

class _SortByDistanceButtonState extends State<SortByDistanceButton> {
  bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          "Distance",
          style: new TextStyle(color: Colors.white, fontSize: 20),
        ),
        color: Colors.blueGrey[500],
        onPressed: () {
          widget.orderBy(1);
        },
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10),
          side: new BorderSide(color: Colors.white, width: 1),
        ),
      ),
    );
  }
}

class SortByAvailabilityButton extends StatefulWidget {
  final void Function(int type) orderBy;

  const SortByAvailabilityButton({this.orderBy});

  @override
  _SortByAvailabilityButtonState createState() =>
      _SortByAvailabilityButtonState();
}

class _SortByAvailabilityButtonState extends State<SortByAvailabilityButton> {
  bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          "Availability",
          style: new TextStyle(color: Colors.white, fontSize: 20),
        ),
        color: Colors.blueGrey[500],
        onPressed: () {
          widget.orderBy(0);
        },
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10),
          side: new BorderSide(color: Colors.white, width: 1),
        ),
      ),
    );
  }
}
