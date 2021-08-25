import 'package:http/http.dart' as http;
import 'dart:async';

import 'destination.dart';
import 'package:dio/dio.dart';

class CarParkAvailabilityAPI {
  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull(
            "https://api.data.gov.sg/v1/transport/carpark-availability"),
        headers: {"Accept": "application/json"});

    return response.body;
  }
}

class GoogleMapsAPI {
  static List<Destination> listOfPlaces = [];

  static Future<Destination> getLatLong(Destination destination) async {
    String id = destination.addressID;

    String baseDetailsURL =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id';

    Response res = await Dio().get(
        '$baseDetailsURL=$id&fields=geometry&key=AIzaSyD-SaR1ASSGucl-Eni0YBzOGChSg2QiZ3w');

    var locationDetails = res.data["result"]["geometry"]["location"];
    double lat = locationDetails["lat"];
    double lng = locationDetails["lng"];

    destination.latitude = lat;
    destination.longitude = lng;

    return destination;
  }

  // ignore: missing_return
  static Future<List<Destination>> findMatches(String input) async {
    if (input.isEmpty) {
    } else {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request =
          '$baseURL?input=$input&key=AIzaSyD-SaR1ASSGucl-Eni0YBzOGChSg2QiZ3w&components=country:sg';

      Response response = await Dio().get(request);

      final predictions = response.data['predictions'];

      listOfPlaces.clear();

      for (var i = 0; i < 5 && i < predictions.length; i++) {
        listOfPlaces.add(Destination(predictions[i]["description"],
            predictions[i]["place_id"], 0.0, 0.0));
      }
      return listOfPlaces;
    }
  }
}
