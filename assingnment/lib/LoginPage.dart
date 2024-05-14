import 'package:assingnment/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Import for date formatting
import 'package:assingnment/NavigationPage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Assuming NavigationPage.dart is in the 'assingnment' package

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  String? lastlogout;

  Future<void> login(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    // Dummy credentials for demonstration
    String dummyEmail = 'user@example.com';
    String dummyPassword = 'password123';

    if (email == dummyEmail && password == dummyPassword) {
      // Get current date and time
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      print('from login page Login time: $formattedDate');

      // Save login time to shared preferences
      await SharedPrefs.instance.saveLoginTime(now);
      // await SharedPrefs.instance.getLoginTime();
      // Get current location

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      String location = '${position.latitude},${position.longitude}';
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');

      // Save location to shared preferences
      await SharedPrefs.instance.saveLoginPlace(position);

      // Navigate to the next screen or perform desired actions
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NavigationPage()),
      );
    } else {
      // Show error message or handle incorrect credentials
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
        ),
      );
    }
  }

  _getLastLogoutTime() async {
    lastlogout = await SharedPrefs.instance.getLogoutTime();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    _getLastLogoutTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                login(context);
              },
              child: const Text('Login'),
            ),
            if (lastlogout != null) const SizedBox(height: 100),
            if (lastlogout != null) Text("Last Logout: $lastlogout")
          ],
        ),
      ),
    );
  }
}
