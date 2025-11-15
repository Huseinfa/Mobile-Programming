import 'User.dart';

void main(){
  // Object Dart ke JSON
  User user = User(
    id: 1,
    name: "John Doe",
    email: "john.doe@example.com",
    createdAt: DateTime.now(),
  );

  Map<String, dynamic> userJson = user.toJson();
  print("User ke JSON: $userJson");

  // JSON ke Object Dart
  Map<String, dynamic> json = {
    'id': 2,
    'name': "Jane Smith",
    'email': "jane.smith@example.com",
    'created_at': DateTime.now().toIso8601String(),
  };

  User userFromJson = User.fromJson(json);
  print("JSON ke User: ${userFromJson.name}, ${userFromJson.email}, ${userFromJson.createdAt}");
}