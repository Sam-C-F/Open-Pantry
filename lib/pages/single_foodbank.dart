import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class SingleFoodbank extends StatelessWidget {
  const SingleFoodbank({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ElevatedButton(
            child: Text('Go back'),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
    );
  }
}

