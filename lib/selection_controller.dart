import 'package:flutter/material.dart';
import 'parking_lot.dart';
import 'parking_lot_manager.dart';
import 'display_car_parks_view.dart';

class SelectionController {
  static void showCarParkInfo(CarPark selectedCarPark, BuildContext context) {
    ParkingLotManager.selectCarPark(selectedCarPark);
    showDialog(
        context: context,
        builder: (context) {
          return CarParkInfo();
        });
  }
}
