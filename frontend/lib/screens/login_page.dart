// login_page.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'welcome_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    final Uri url = Uri.parse('${dotenv.env['API_URL_token']}');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': usernameController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final authToken = jsonDecode(response.body)['token'];
      await _saveTokenToFile(authToken);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomeScreen(
            username: usernameController.text,
            authToken: authToken,
          ),
        ),
      );
    } else {
      print('Login failed. Status code: ${response.statusCode}');
    }
  }

  Future<void> _saveTokenToFile(String authToken) async {
    final Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory();
    final File tokenFile = File('${appDocumentsDirectory.path}/auth_token.txt');

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
