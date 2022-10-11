// class User {
//   final String name;
//   final String district;

//   const User({
//     required this.name,
//     required this.district,
//   });

//   static User fromJson(json) => User(
//         name: json["name"],
//         district: json["politics"]["district"],
//       );
// }

class User {
  String name, postcode;

  User(this.name, this.postcode);

  User.fromJson(Map json)
      : name = json['name'],
        postcode = json['postcode'];

  Map toJson() {
    return {'name': name, 'postcode': postcode};
  }
}
