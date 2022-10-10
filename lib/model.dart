class User {
  final String name;
  final String district;

  const User({
    required this.name,
    required this.district,
  });

  static User fromJson(json) => User(
        name: json["name"],
        district: json["politics"]["district"],
      );
}
