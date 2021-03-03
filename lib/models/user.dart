class User {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String username;
  bool isActive;

  User.fromMap(dynamic json) {
    this.id = json['id'];
    this.createdAt = DateTime.parse(json['createdAt']);
    this.updatedAt = DateTime.parse(json['updatedAt']);
    this.username = json['username'];
    this.isActive = json['isActive'];
  }
}
