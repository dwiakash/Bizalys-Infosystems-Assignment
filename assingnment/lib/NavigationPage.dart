import 'dart:html';
import 'package:assingnment/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:assingnment/SavedData.dart'; // Assuming SavedData.dart is in the 'assingnment' package

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  void getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    print(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Geolocator')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                getLocation(); // Call the getLocation function here
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SavedData()),
                );
              },
              child: Text('Get Login details'),
            ),
          ],
        ),
      ),
    );
  }
}
