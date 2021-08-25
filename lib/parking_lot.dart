class CarPark {
  String parkID, address;
  int countAvailable, countTotal;
  double availability, distance, latitude, longitude;

  CarPark(String parkID, String address, double latitude, double longitude) {
    this.parkID = parkID;
    this.address = address;
    this.countAvailable = 0;
    this.countTotal = 1;
    this.availability = (countTotal - countAvailable) / countTotal;
    this.distance = 0.0;
    this.latitude = latitude;
    this.longitude = longitude;
  }
}
