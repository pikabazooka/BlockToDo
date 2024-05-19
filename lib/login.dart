import 'package:flutter/material.dart';
import 'signup.dart';
/*
Future<http.Response> loginRequest(String username, String password) {
  return http.post(
    Uri.parse('https://BlockToDo.deveshsingarh78.repl.co/hi'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },

    body: jsonEncode(<String, String>{
      'username': username,
      'password' : password,
    }),
  );
}*/

// create a page for login.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  String _username_input = "";
  String _password_input = "";
  String _error_message = "";

  void usernameChanged(String new_username) {
    _username_input = new_username;
  }

  void passwordChanged(String new_password) {
    _password_input = new_password;
  }

  void errorMessage(String err_msg) {
    setState(() {
      _error_message = err_msg;
    });
    Future.delayed(Duration(seconds : 2), () {
      setState(() {
        _error_message = "";
      });
    });
  }

  void attemptLogin() {
    if (_username_input != "" && _password_input != "") {

    
    } else {
      errorMessage("Invalid username or password.");
    }
  }

  void changeToSignup(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const SignupPage();
        }
      )
    );
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle : true,
        title: const Text("Log In Page",
          textAlign: TextAlign.center,
          style : const TextStyle(
            color : Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              const Image(
                image: AssetImage("lib/images/emi.png"),
              ),
              const SizedBox(height: 10),
              const Text('Username'),
              TextField(
                onChanged: usernameChanged,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your username',
                ),
              ),
              const SizedBox(height: 10),
              const Text('Password'),
              TextField(
                onChanged: passwordChanged,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed : attemptLogin,
                child: const Text('Login'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  changeToSignup(context);
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 10),
              Text(
                _error_message, 
                style : const TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
        )
      ),
    );
  }
}