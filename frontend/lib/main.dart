import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    final Uri url = Uri.parse('http://localhost:8000/api-token-auth/');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': usernameController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Assuming the server responds with a token
      final authToken = jsonDecode(response.body)['token'];
      await _saveTokenToFile(authToken);
      print('Login successful. Token: $authToken');

      // Navigate to the WelcomeScreen on successful login
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomeScreen(
              username: usernameController.text, authToken: authToken),
        ),
      );
    } else {
      print('Login failed. Status code: ${response.statusCode}');
      // Handle login failure here
    }
  }

  Future<void> _saveTokenToFile(String authToken) async {
    final Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory();
    final File tokenFile = File('${appDocumentsDirectory.path}/auth_token.txt');

    // Write the token to the file
    await tokenFile.writeAsString(authToken);
    print('Token saved to file: ${tokenFile.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

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
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}
