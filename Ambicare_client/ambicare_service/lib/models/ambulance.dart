class Ambulance {
  late String id;
  late String registrationNumber;
  late Map<String, dynamic> location;
  late bool isAvailable;
  late String type;
  late String farePerKm;
  late Map<String, dynamic> ownedBy;
  late Map<String, dynamic>? driver;

  Ambulance.fromData({required Map<String, dynamic> data}) {
    id = data["_id"];
    registrationNumber = data["registrationNumber"];
    location = data["location"];
    isAvailable = data["isAvailable"];
    type = data["type"];
    farePerKm = data["farePerKm"].toString();
    ownedBy = data["ownedBy"];
    driver = data["driver"];
  }
}
