import 'package:assingnment/LoginPage.dart';
import 'package:assingnment/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Assuming SavedData.dart is in the 'assingnment' package

class SavedData extends StatefulWidget {
  const SavedData({Key? key}) : super(key: key);

  @override
  _SavedDataState createState() => _SavedDataState();
}

class _SavedDataState extends State<SavedData> {
  void getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    print(position);
  }

  String? loginTime;
  Map<String, double>? loginPlace;

  getLoginTime() async {
    loginTime = await SharedPrefs.instance.getLoginTime();
    setState(() {});
  }

  getLoginPlace() async {
    loginPlace = await SharedPrefs.instance.getLoginPlace();
    setState(() {});
  }

  @override
  void initState() {
    getLoginTime();
    getLoginPlace();
    // TODO: implement initState
    super.initState();
  }

  double distance = 0.0;
  final double designatedDistance = 50;
  bool isDataFetch = false;
  Future<void> calculateDistance() async {
    setState(() {
      isDataFetch = false;
    });
    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Define the coordinates of the other location (live location)
    double otherLat = 25.4358; // Example latitude
    double otherLong = 81.8463; // Example longitude

    // Calculate distance using Haversine formula
    double result = await Geolocator.distanceBetween(
        position.latitude, position.longitude, otherLat, otherLong);

    setState(() {
      distance = result;
      isDataFetch = true;
    });
    if (distance > designatedDistance) {
      // Perform logout operation (e.g., navigate to logout screen)
      _logoutUser();
    } else {
      // User is within designated distance, allow normal operations
      // Here you can perform other operations or update UI accordingly
      _allowNormalOperations();
    }
  }

  void _allowNormalOperations() {
    // This method can be used to enable normal app operations
    print('User is within designated distance. Normal operations allowed.');
  }

  void _logoutUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    SharedPrefs.instance.saveLogoutTime(DateTime.now());
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Geolocator')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loginTime != null)
              Text('Login time is:- $loginTime')
            else
              const CircularProgressIndicator(),
            if (loginPlace != null)
              Text('Login place is:- $loginPlace')
            else
              const CircularProgressIndicator(),
            ElevatedButton(
              onPressed: () {
                calculateDistance();
              },
              child: const Text('Calculate Distance'),
            ),
            const SizedBox(height: 20),
            if (isDataFetch)
              Text(
                'Distance: ${distance.toStringAsFixed(2)} meters',
                style: const TextStyle(fontSize: 20),
              ),
          ],
        ),
      ),
    );
  }
}
