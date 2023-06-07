import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'dart:convert';
import 'package:book_recognizer_frontend/screens/camera.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();

  var _isLogin = true;

  var _enteredFirstName = '';
  var _enteredLastName = '';
  var _enteredUsername = '';
  var _enteredPassword = '';

  String getBackendUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000';
    } else {
      return 'http://localhost:8000';
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 71, 200, 71),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  Future<void> _navigateToPreferences() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CameraScreen(),
      ),
    );
  }

  void _submit() async {
    final isValid = _form.currentState!.validate();
    final backendUrl = getBackendUrl();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    if (_isLogin) {
      // Log users in
      var request =
          http.MultipartRequest('POST', Uri.parse('$backendUrl/auth/token'));
      request.headers['Content-Type'] = 'application/x-www-form-urlencoded';
      request.fields['username'] = _enteredUsername;
      request.fields['password'] = _enteredPassword;
      request.fields['grant_type'] = 'password';

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        _showSuccessSnackBar('Logged in successfully.');
        await _navigateToPreferences();
      } else {
        String errorMessage;
        if (response.statusCode == 401) {
          errorMessage = 'Login failed. Please try again.';
          _showErrorSnackBar(errorMessage);
        }
      }
    } else {
      var response = await http.post(Uri.parse('$backendUrl/auth/'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'username': _enteredUsername,
            'password': _enteredPassword,
            'first_name': _enteredFirstName,
            'last_name': _enteredLastName,
            'book_preferences': <String>[]
          }));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 30, bottom: 20, left: 20, right: 20),
                width: 200,
                child: Image.asset('assets/images/book-icon.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Visibility(
                            visible: !_isLogin,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'First Name'),
                              keyboardType: TextInputType.name,
                              autocorrect: false,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a valid first name.';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                _enteredFirstName = value!;
                              },
                            ),
                          ),
                          Visibility(
                            visible: !_isLogin,
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Last Name'),
                              keyboardType: TextInputType.name,
                              autocorrect: false,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a valid last name.';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                _enteredLastName = value!;
                              },
                            ),
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Username'),
                            keyboardType: TextInputType.name,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a valid username.';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _enteredUsername = value!;
                            },
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer),
                            child: Text(_isLogin ? 'Login' : 'Sign up'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(_isLogin
                                ? 'Create an account'
                                : 'I already have an account - Login.'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
