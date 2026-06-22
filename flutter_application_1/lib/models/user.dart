class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? plateNumber;

  User({required this.id, required this.name, required this.email, this.phone, this.plateNumber});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      plateNumber: json['plate_number'],
    );
  }
}