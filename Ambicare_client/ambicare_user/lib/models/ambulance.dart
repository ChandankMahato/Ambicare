class Ambulance {
  late String id;
  late String registrationNumber;
  late Map<String, dynamic> location;
  late bool isAvailable;
  late String type;
  late int farePerKm;
  late Map<String, dynamic> driver;
  late Map<String, dynamic> ownedBy;

  Ambulance.fromData({required Map<String, dynamic> data}) {
    id = data["_id"];
    registrationNumber = data["registrationNumber"];
    location = data["location"];
    isAvailable = data["isAvailable"];
    type = data["type"];
    farePerKm = data["farePerKm"];
    // driver = {
    //   '_id': '625017da2441364ea646ca1e',
    //   'name': 'Chandan',
    //   'phoneNumber': '9811771892'
    // };
    driver = data["driver"];
    ownedBy = data["ownedBy"];
  }
}
