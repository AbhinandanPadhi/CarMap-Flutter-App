import 'dart:math';

import 'dart:convert' show json;
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'main_controller.dart';
import 'parking_lot.dart';
import 'api_controller.dart';
import 'destination_manager.dart';

class ParkingLotManager implements Subject {
  static List<CarPark> allCarParkList = [];
  static List<CarPark> neededCarParkList = [];
  static CarPark selectedCarPark;
  static int sortType = 1;
  static List<Observer> observers = [];

  static int attachCount = 0;

  static void attach(Observer o) {
    ParkingLotManager.observers.add(o);

    if (attachCount == 0) {
      getAllCarParkList();
      attachCount = 1;
    }
  }

  static void detach(Observer o) {
    ParkingLotManager.observers.remove(o);
  }

  static void notify() {
    for (Observer o in observers) {
      o.update();
    }
  }

  static List getData() {
    return [neededCarParkList, selectedCarPark];
  }

  static void getAllCarParkList() async {
    String path = "/assets/hdb-carpark-information.csv";
    final File file = File('$path');
    Stream<List> inputStream = file.openRead();
    int count = 0;
    inputStream.transform(utf8.decoder).transform(new LineSplitter()).listen(
        (String line) {
      if (count != 0) {
        List row = line.split(',');
        CarPark x = new CarPark(
            row[0], row[1], double.parse(row[2]), double.parse(row[3]));
        allCarParkList.add(x);
        neededCarParkList.add(x);
      }
      count += 1;
    }, onDone: () {}, onError: (e) {});

    ParkingLotManager.notify();
    getNeededCarParkList(5.0);
  }

  static getNeededCarParkList(double range) async {
    ParkingLotManager.neededCarParkList.clear();

    var a = await CarParkAvailabilityAPI().getData();
    var govtData = json.decode(a);

    for (int i = 0; i < allCarParkList.length; i++) {
      var distance = getDistance(
              DestinationManager.selectedDestination.latitude,
              DestinationManager.selectedDestination.longitude,
              allCarParkList[i].latitude,
              allCarParkList[i].longitude)
          .abs();
      distance = double.parse(distance.toStringAsFixed(1));
      if (distance <= range) {
        CarPark tempCarPark = new CarPark(
            allCarParkList[i].parkID,
            allCarParkList[i].address,
            allCarParkList[i].latitude,
            allCarParkList[i].longitude);
        tempCarPark.distance = distance;
        ParkingLotManager.neededCarParkList.add(tempCarPark);
      }
    }

    var pos;
    for (pos = 1; pos < govtData["items"][0]['carpark_data'].length; pos++) {
      String number =
          govtData["items"][0]['carpark_data'][pos]['carpark_number'];
      int countAvailable = int.parse(govtData["items"][0]['carpark_data'][pos]
          ['carpark_info'][0]['lots_available']);
      int countTotal = int.parse(govtData["items"][0]['carpark_data'][pos]
          ['carpark_info'][0]['total_lots']);
      int index =
          neededCarParkList.indexWhere((carPark) => carPark.parkID == number);
      if (index != -1) {
        neededCarParkList[index].parkID = number;
        neededCarParkList[index].countAvailable = countAvailable;
        neededCarParkList[index].countTotal = countTotal;
        neededCarParkList[index].availability =
            (countTotal - countAvailable) / countTotal;
      }
    }

    ParkingLotManager.notify();
    ParkingLotManager.sortCarParkList(ParkingLotManager.sortType);
  }

  static void sortCarParkList(int type) {
    ParkingLotManager.sortType = type;
    if (type == 1) {
      neededCarParkList.sort((a, b) => a.distance.compareTo(b.distance));
    } else {
      neededCarParkList
          .sort((a, b) => b.countAvailable.compareTo(a.countAvailable));
    }
    ParkingLotManager.notify();
  }

  static void selectCarPark(CarPark enteredCarPark) {
    selectedCarPark = enteredCarPark;
    ParkingLotManager.notify();
  }

  static double getDistance(lat1, lon1, lat2, lon2) {
    var R = 6371;
    const pi = 3.1415;
    var dLat = (lat2 - lat1) * pi / 180;
    var dLon = (lon2 - lon1) * pi / 180;
    var a = 0.5 -
        cos(dLat) / 2 +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) * (1 - cos(dLon)) / 2;

    return R * 2 * asin(sqrt(a));
  }
}
