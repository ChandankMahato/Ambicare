class Ambulance {
  late String id;
  late String registrationNumber;
  late bool isAvailable;
  late String type;
  late String farePerKm;
  late String service;

  Ambulance.fromData({required Map<String, dynamic> data}) {
    id = data["_id"];
    registrationNumber = data["registrationNumber"].toString();
    isAvailable = data["isAvailable"];
    type = data["type"];
    farePerKm = data["farePerKm"].toString();
    service = data["ownedBy"]["ambulanceService"];
  }
}
