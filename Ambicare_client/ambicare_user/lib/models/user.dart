class User {
  late String id;
  late String phoneNumber;
  late String name;
  late String email;

  User.fromData({required Map<String, dynamic> data}) {
    id = data["_id"];
    phoneNumber = data["phoneNumber"].toString();
    name = data["name"];
    email = data["email"];
  }
}
