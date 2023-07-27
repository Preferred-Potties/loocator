import 'dart:developer';

import 'package:first_flutter/Screens/home_page.dart';
import 'package:first_flutter/Screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  RegisterScreen createState() => RegisterScreen();
}

class RegisterScreen extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  static var jsonResponse = '';
  bool isLoading = false;
  // bool registrationResult = false;

  signUp(String username, String email, String password) async {
    String url = "http://10.0.2.2:3000/api/v1/users";
    Map body = {"username": username, "email": email, "password": password};
    var client = http.Client();
    var res = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
    log(body.toString());
    log(res.statusCode.toString());
    if (res.statusCode == 200) {
      var jsonResponse = json.decode(res.body);
      log("Response status: ${res.statusCode}");
      log('Response body: $jsonResponse');
      if (jsonResponse.toString().length <= 5) {
        setState(() {
          isLoading = false;
        });
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? token = jsonResponse['token'] as int?;
      await prefs.setInt('token', token ?? 0);
      return 'success';
    } else {
      setState(() {
        isLoading = false;
      });
      return 'failure';
    }
  }

  Future<String> signIn(String username, String pass) async {
    String url = "http://10.0.2.2:3000/api/v1/users/sessions";
    Map<String, dynamic> body = {'username': username, "password": pass};
    log(body.toString());

    var res = await http.Client().post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body));
    if (res.statusCode == 200) {
      log("Response status: ${res.statusCode}");

      var jsonResponse = json.decode(res.body);
      log('Response $jsonResponse');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', jsonResponse["token"]);
      log(prefs.toString());
      log('PREFS ^^^^^');

      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      }

      return 'success';
    } else {
      setState(() {
        isLoading = false;
      });
      return 'failure';
    }
  }

  void registerAndLoginUser(
      String username, String email, String password) async {
    // Register user
    await signUp(username, email, password).then((registrationResult) async {
      if (registrationResult == 'success') {
        // Registration successful, now login user
        await signIn(username, password).then((loginResult) {
          if (loginResult == 'success') {
            // Login successful
            // change logs to pop-ups
            log('User logged in successfully');
          } else {
            // Login failed
            showDialog(
              context: context,
              builder: (_) => const AlertDialog(
                title: Text('Login'),
                content: Text('Failed to login user.'),
              ),
            );
            log('Failed to login user');
          }
        });
      } else {
        // Registration failed
        showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            title: Text('Registration'),
            content: Text('Failed to register user.'),
          ),
        );
        log('Failed to register user');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: const Text(
                "Register",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2661FA),
                    fontSize: 36),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: "Username"),
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: ElevatedButton(
                onPressed: usernameController.text == "" ||
                        passwordController.text == ""
                    ? null
                    : () {
                        setState(() {
                          isLoading = true;
                        });
                        registerAndLoginUser(usernameController.text,
                            emailController.text, passwordController.text);
                      },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    padding: const EdgeInsets.all(0)),
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  width: size.width * 0.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      gradient: const LinearGradient(colors: [
                        Color.fromARGB(255, 255, 136, 34),
                        Color.fromARGB(255, 255, 177, 41)
                      ])),
                  padding: const EdgeInsets.all(0),
                  child: const Text(
                    "Sign Up",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: GestureDetector(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()))
                },
                child: const Text(
                  "Already Have an Account? Login",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2661FA)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
