import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:open_pantry/api.dart';
import 'package:open_pantry/models/model.dart';
import 'package:open_pantry/pages/single_foodbank.dart';
import 'package:http/http.dart' as http;
import 'package:snapshot/snapshot.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var users = <User>[];
  _getUsers() {
    API.getUsers().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        users = list.map((model) {
          return User.fromJson(model);
        }).toList();
      });
    });
  }

  initState() {
    super.initState();
    _getUsers();
  }

  dispose() {
    super.dispose();
  }

  @override
  build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("User List"),
        ),
        body: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(users[index].name),
                  subtitle: Text(users[index].postcode),
                  trailing: ElevatedButton(
                      child: const Text('Go'),
                      onPressed: () async {
                        String id = users[index].slug;
                        var url = Uri.parse(
                            'https://www.givefood.org.uk/api/2/foodbank/$id/');
                        var response = await http.get(url);
                        var data = jsonDecode(response.body);
                        String name = data['name'];
                        String address = data['address'];
                        String latLng = data['lat_lng'];
                        String urls = data['urls']['homepage'];
                        String needs = data['need']['needs'];

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FoodBank(
                                    passedName: name,
                                    passedAddress: address,
                                    passedLatLng: latLng,
                                    passedUrls: urls,
                                    passedNeeds: needs)));
                      }));
            }));
  }
}


// Widget buildUsers(List<User> users) => ListView.builder(
//     itemCount: users.length,
//     itemBuilder: (context, index) {
//       final user = users[index];

//       return Card(
//         child: ListTile(
//           title: Text(user.name),
//           subtitle: Text(user.postcode),
//         ),
//       );
//     });
// @override
// Widget build(BuildContext context) => Scaffold(
//       appBar: AppBar(
//         title: const Text("Open Pantry"),
//         centerTitle: true,
//       ),
//       body: Center(
//           child: FutureBuilder<List<User>>(
//               future: usersFuture,
//               builder: (context, snapshot) {
//                 print(snapshot.data);
//                 if (snapshot.hasData) {
//                   final users = snapshot.data!;
//                   return buildUsers(users);
//                 } else {
//                   return const Text("No user data");
//                 }
//               })),
//     );
