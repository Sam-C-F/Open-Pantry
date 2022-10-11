import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class FoodBank extends StatefulWidget {
  FoodBank(
      {Key? key,
      required this.passedName,
      required this.passedAddress,
      required this.passedLatLng,
      required this.passedUrls,
      required this.passedNeeds})
      : super(key: key);
  final String passedName;
  final String passedAddress;
  final String passedLatLng;
  final String passedUrls;
  final String passedNeeds;
  @override
  State<FoodBank> createState() => _MyWidgetState();
}

// class _FoodBankNeedsState extends State<FoodBank> {
//   final _saved = <String>{};
//   final _suggestions = <String>[];
//   void _pushSaved() {
//     Navigator.of(context).push((MaterialPageRoute<void>(builder: (context) {
//       final tiles = _saved.map((need) {
//         return ListTile(
//           title: Text(need),
//         );
//       });
//       final divided = tiles.isNotEmpty
//           ? ListTile.divideTiles(
//               context: context,
//               tiles: tiles,
//             ).toList()
//           : <Widget>[];
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('My Shopping List'),
//         ),
//         body: ListView(children: divided),
//       );
//     })));
//   }
// }

class _MyWidgetState extends State<FoodBank> {
  @override
  Widget build(BuildContext context) {
    final List<String> needsList = widget.passedNeeds.split('\n');
    return MaterialApp(
        title: 'FoodBank',
        home: Scaffold(
            appBar: AppBar(
                title: Text('${widget.passedName}'),
                centerTitle: true,
                leading: ElevatedButton(
                    child: Text('<'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })),
            body: ListView.separated(
                itemCount: needsList.length,
                separatorBuilder: (BuildContext context, index) => const Divider(),
                itemBuilder:(BuildContext context, index) {
                  return ListTile(
                    title: Text(needsList[index]),
                    tileColor: Colors.blue[100],
                  );
                })
            ));
  }
}
