import 'destination.dart';
import 'destination_manager.dart';
import 'main_controller.dart';

class SearchForDestinationController implements Observer {
  void update() {}
  void enterDestinationControl(String text) =>
      DestinationManager.getDestinationList(text);
  void selectDestinationControl(Destination selectedDestination) =>
      DestinationManager.selectDestination(selectedDestination);
}
