class UserModel {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String? uid;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.uid,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'uid': uid,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        password: map['password'] ?? '',
        uid: map['uid'],
      );
}