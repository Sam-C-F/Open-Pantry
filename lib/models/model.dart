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
  String name, postcode, slug;

  User(this.name, this.postcode, this.slug);

  User.fromJson(Map json)
      : name = json['name'],
        postcode = json['postcode'],
        slug = json['slug'];

  Map toJson() {
    return {'name': name, 'postcode': postcode, 'slug': slug};
  }
}
