import 'parking_lot_manager.dart';
import 'main_controller.dart';

class SearchRadiusController implements Observer {
  static void updateSearchRadius(int range) =>
      ParkingLotManager.getNeededCarParkList(range.toDouble());
  void update() {}
}

class sortTypeController implements Observer {
  static void switchSortType(int type) =>
      ParkingLotManager.sortCarParkList(type);
  void update() {}
}

class viewTypeController implements Observer {
  static int switchView(int type) => type;
  void update() {}
}
