class UserModel {
  final int id;
  final String name;
  final String email;
  final String password; // Renomeada para corresponder à sua coluna "password"
  final String healthGoals;
  final String gender;
  final String dateOfBirth;
  final double weight;
  final double height;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.healthGoals,
    required this.gender,
    required this.dateOfBirth,
    required this.weight,
    required this.height,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'health_goals': healthGoals,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'weight': weight,
      'height': height,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      healthGoals: map['health_goals'],
      gender: map['gender'],
      dateOfBirth: map['date_of_birth'],
      weight: map['weight'],
      height: map['height'],
    );
  }
}
