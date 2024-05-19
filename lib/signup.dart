import 'package:flutter/material.dart';
import "login.dart";

// create a page for sign up;
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  String _username_input = "";
  String _password_confirmation_input = "";
  String _password_input = "";
  String _error_message = "";

  void usernameChanged(String new_username) {
    _username_input = new_username;
  }

  void passwordChanged(String new_password) {
    _password_input = new_password;
  }

  void passwordConfirmationChanged(String new_password_confirmation) {
    _password_confirmation_input = new_password_confirmation;
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

  void attemptSignUp() {
    if (_username_input == "") {
      errorMessage("Invalid username");
    } else if (_password_input == "") {
      errorMessage("Invalid password");
    } else if (_password_input != _password_confirmation_input) {
      errorMessage("Password does not match confirmation password.");
    } else {
      // attempt sign up
    };
  }

  void changeToLogin(BuildContext context) {
    // updates the page;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const LoginPage();
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
        title: const Text("Sign Up Page",
          textAlign: TextAlign.center,
          style : const TextStyle(
            color : Colors.white,
          ),
        ),
      ),
      body : Padding(
         padding : const EdgeInsets.all(8),
         child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            const Text('Confirm Password'),
            TextField(
              onChanged: passwordConfirmationChanged,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Confirm your password',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed : attemptSignUp,
              child: const Text('Sign Up'),
            ),
              const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                changeToLogin(context);
              },
              child: const Text('Back to Login'),
            ),
            const SizedBox(height: 10),
            Text(
              _error_message, 
              style : const TextStyle(
                color: Colors.red,
              ),
            ),
          ],
         ),
      ),
    );
  }
}
