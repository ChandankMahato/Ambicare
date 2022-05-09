class Request {
  late String id;
  late bool isPending;
  // late bool isCompleted;
  late Map<String, dynamic> pickUpLocation;
  late Map<String, dynamic> destination;
  late Map<String, dynamic> requestedBy;
  late Map<String, dynamic> requestedTo;
  late Map<String, dynamic> ambulance;

  Request.fromData({required Map<String, dynamic> data}) {
    id = data["_id"];
    isPending = data["isPending"];
    // isCompleted = data["isCompleted"];
    pickUpLocation = data["pickupLocation"];
    destination = data["destination"];
    requestedBy = data["requestedBy"];
    requestedTo = data["requestedTo"];
    ambulance = data["ambulance"];
  }
}
