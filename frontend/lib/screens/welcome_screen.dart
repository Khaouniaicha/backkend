// welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WelcomeScreen extends StatelessWidget {
  final String username;
  final String authToken;

  WelcomeScreen({required this.username, required this.authToken});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, $username!'),
            SizedBox(height: 16.0),
            Text('Access Token: $authToken'),
          ],
        ),
      ),
      // Move the ElevatedButton outside the Column widget
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GeocodePage(authToken: authToken),
            ),
          );
        },
        child: Icon(Icons.map),
      ),
    );
  }
}

class GeocodePage extends StatefulWidget {
  final String authToken;

  GeocodePage({required this.authToken});

  @override
  _GeocodePageState createState() => _GeocodePageState();
}

class _GeocodePageState extends State<GeocodePage> {
  TextEditingController addressController = TextEditingController();
  String result = '';

  Future<void> getLatLon(String authToken) async {
    final String baseUrl = '${dotenv.env['baseUrl']}';
    final String geocodeEndpoint =
        '/geocode/?address=${addressController.text}';
    final String url = '$baseUrl$geocodeEndpoint';

    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      if (response.statusCode == 200) {
        setState(() {
          result = response.body;
        });
      } else {
        setState(() {
          result = 'Failed to get latitude and longitude';
        });
      }
    } catch (e) {
      setState(() {
        result = 'Failed to get latitude and longitude';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geocode Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Enter Address'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Pass the authToken obtained during login
                getLatLon(widget.authToken);
              },
              child: Text('Get Latitude and Longitude'),
            ),
            SizedBox(height: 16),
            Text('Result: $result'),
          ],
        ),
      ),
    );
  }
}
