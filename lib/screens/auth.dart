import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:book_recognizer_frontend/screens/camera.dart';
import 'package:book_recognizer_frontend/screens/preferences.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();

  var _isLogin = true;

  var _enteredFirstName = '';
  var _enteredLastName = '';
  var _enteredUsername = '';
  var _enteredPassword = '';

  String getBackendUrl() {
    // if (Platform.isAndroid) {
    //   return 'http://10.0.2.2:8000';
    // } else {
    //   return 'http://localhost:8000';
    // }

    // return 'http://192.168.178.57:8000';

    return 'http://18.135.170.219:80';
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
        builder: (context) => const PreferencesScreen(),
      ),
    );
  }

  Future<void> _navigateToCamera() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CameraScreen(),
      ),
    );
  }

  Future<void> _saveEmptyPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('book_preferences', []);
  }

  void _submit() async {
    FocusScope.of(context).requestFocus(FocusNode());

    final isValid = _form.currentState!.validate();
    final backendUrl = getBackendUrl();
    String bearerToken;

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

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        String accessToken = responseBody['access_token'];
        await storage.write(key: 'access_token', value: accessToken);
        bearerToken = accessToken;

        var preferencesResponse = await http
            .get(Uri.parse('$backendUrl/user/book_preferences'), headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        });

        // If server returns a 200 OK response, parse the JSON.
        List<dynamic> preferencesResponseBody =
            json.decode(preferencesResponse.body);

        if (preferencesResponseBody.isEmpty) {
          _navigateToPreferences();
        } else {
          print(preferencesResponse.body);
          _navigateToCamera();
        }
      } else {
        String errorMessage;
        if (response.statusCode == 401) {
          errorMessage = 'Login failed. Please try again.';
        } else {
          errorMessage = 'Unknown error occurred while logging in.';
        }
        _showErrorSnackBar(errorMessage);
      }
    } else {
      // Register new user
      var response = await http.post(
        Uri.parse('$backendUrl/auth/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': _enteredUsername,
          'password': _enteredPassword,
          'first_name': _enteredFirstName,
          'last_name': _enteredLastName,
          'book_preferences': <String>[],
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await _saveEmptyPreferences();
        _showSuccessSnackBar(
            'Account created successfully. Please log in to continue.');
        Future.delayed(Duration.zero, () {
          setState(() {
            _isLogin = true;
          });
        });
      } else {
        String errorMessage = 'Unknown error occurred while creating account.';
        if (response.statusCode == 400) {
          final jsonResponse = json.decode(response.body);
          if (jsonResponse.containsKey('username')) {
            final usernameError = jsonResponse['username'][0];
            errorMessage = 'Username: $usernameError';
          } else if (jsonResponse.containsKey('password')) {
            final passwordError = jsonResponse['password'][0];
            errorMessage = 'Password: $passwordError';
          }
        } else if (response.statusCode == 500) {
          errorMessage = 'Server Error: please try again later';
        }
        _showErrorSnackBar(errorMessage);
      }
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
                              textCapitalization: TextCapitalization.sentences,
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
                              textCapitalization: TextCapitalization.sentences,
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
