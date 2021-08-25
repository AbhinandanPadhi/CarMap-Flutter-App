import 'package:flutter/material.dart';
import 'selection_controller.dart';
import 'main_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'parking_lot_manager.dart';
import 'parking_lot.dart';

class MapView extends StatefulWidget {
  const MapView();

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> implements Observer {
  List<CarPark> carParkList = [];
  List<Marker> allMarkers = [];
  CarPark selectedCarPark;

  double colour;

  void update() {
    List data = ParkingLotManager.getData();
    this.setState(() {
      this.carParkList = data[0];
      this.selectedCarPark = data[1];
      allMarkers.clear();
      for (CarPark carPark in carParkList) {
        if (carPark.availability < 0.4) {
          colour = BitmapDescriptor.hueGreen;
        } else if (carPark.availability >= 0.4 && carPark.availability <= 0.8) {
          colour = BitmapDescriptor.hueOrange;
        } else {
          colour = BitmapDescriptor.hueRed;
        }
        allMarkers.add(Marker(
            markerId: MarkerId(carPark.parkID),
            draggable: false,
            icon: BitmapDescriptor.defaultMarkerWithHue(colour),
            onTap: () {
              print(carPark.parkID);
              SelectionController.showCarParkInfo(carPark, context);
            },
            position: LatLng(carPark.latitude, carPark.longitude)));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    ParkingLotManager.attach(this);
    List data = ParkingLotManager.getData();
    this.carParkList = data[0];
    this.selectedCarPark = data[1];

    for (CarPark carPark in carParkList) {
      if (carPark.availability < 0.4) {
        colour = BitmapDescriptor.hueGreen;
      } else if (carPark.availability >= 0.4 && carPark.availability <= 0.8) {
        colour = BitmapDescriptor.hueOrange;
      } else {
        colour = BitmapDescriptor.hueRed;
      }
      allMarkers.add(Marker(
          markerId: MarkerId(carPark.parkID),
          draggable: false,
          icon: BitmapDescriptor.defaultMarkerWithHue(colour),
          onTap: () {
            print(carPark.parkID);
            SelectionController.showCarParkInfo(carPark, context);
          },
          position: LatLng(carPark.latitude, carPark.longitude)));
    }
  }

  @override
  void dispose() {
    ParkingLotManager.detach(this);
    super.dispose();
  }

  GoogleMapController mapController;
  String _mapStyle;
  final LatLng _center = const LatLng(1.359, 103.80);

  void _onMapCreated(GoogleMapController controller) =>
      mapController = controller;

  bool active;
  int zoomLevel;
  List<CarPark> listOfPins; //List should be of type coordinates

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 20,
        height: MediaQuery.of(context).size.height - 300,
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 10.25,
          ),
          markers: Set.from(allMarkers),
        ),
      ),
    );
  }
}
