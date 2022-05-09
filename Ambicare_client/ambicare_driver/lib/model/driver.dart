class Driver {
  late String id;
  late String phoneNumber;
  late String name;
  late String ambulance;
  late String service;

  Driver.fromData({required Map<String, dynamic> data}) {
    id = data["_id"];
    phoneNumber = data["phoneNumber"].toString();
    name = data["name"];
    ambulance = data["ambulance"];
    service = data["worksFor"]["ambulanceService"];
  }
}
