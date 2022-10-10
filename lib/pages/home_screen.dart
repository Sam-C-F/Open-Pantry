import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:open_pantry/model.dart';
import 'package:open_pantry/pages/single_foodbank.dart';
import 'package:http/http.dart' as http;
import 'package:snapshot/snapshot.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Center(
//           child: ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).push(
//                     MaterialPageRoute(builder: (context) => SingleFoodbank()));
//               },
//               child: Text("Go to next page")),
//         ),
//       ),
//     );
//   }
// }
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<User>> usersFuture = getUsers();

  static Future<List<User>> getUsers() async {
    const url = "https://www.givefood.org.uk/api/2/foodbanks/";
    final response = await http.get(Uri.parse(url));
    final body = json.decode(response.body);
    return body.map<User>(User.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Open Pantry"),
          centerTitle: true,
        ),
        body: Center(
            child: FutureBuilder<List<User>>(
                future: usersFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final users = snapshot.data!;
                    return buildUsers(users);
                  } else {
                    return const Text("No user data");
                  }
                })),
      );

  Widget buildUsers(List<User> users) => ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        return Card(
          child: ListTile(
            title: Text(user.name),
            subtitle: Text(user.district),
          ),
        );
      });
}
