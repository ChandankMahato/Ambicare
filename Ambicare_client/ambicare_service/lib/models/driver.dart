class Driver {
  late String id;
  late String phoneNumber;
  late String name;
  late Map<String, dynamic> worksFor;
  late String? ambulance;

  Driver.fromData({required Map<String, dynamic> data}) {
    id = data["_id"];
    phoneNumber = data["phoneNumber"].toString();
    name = data["name"];
    worksFor = data["worksFor"];
    ambulance = data["ambulance"];
  }
}
