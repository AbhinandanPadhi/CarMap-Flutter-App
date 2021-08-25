import 'destination.dart';
import 'main_controller.dart';
import 'api_controller.dart';

class DestinationManager implements Subject {
  static List<Destination> destinationList = [];
  static Destination selectedDestination;
  static List<Observer> observers = [];

  static void attach(Observer o) => DestinationManager.observers.add(o);
  static void detach(Observer o) => DestinationManager.observers.remove(o);
  static void notify() {
    for (Observer o in observers) o.update();
  }

  static List getData() => [destinationList, selectedDestination];

  //Destination manager functions
  static void getDestinationList(String text) async {
    DestinationManager.destinationList = await GoogleMapsAPI.findMatches(text);
    DestinationManager.notify();
  }

  static void selectDestination(Destination selectedDestination) async {
    DestinationManager.selectedDestination = selectedDestination;
    DestinationManager.selectedDestination =
        await GoogleMapsAPI.getLatLong(selectedDestination);
    DestinationManager.notify();
  }
}
