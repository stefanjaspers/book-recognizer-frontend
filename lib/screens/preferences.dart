import 'dart:convert';
import 'dart:io';

import 'package:book_recognizer_frontend/screens/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:book_recognizer_frontend/providers/genres_provider.dart';
import 'package:book_recognizer_frontend/screens/camera.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PreferencesScreenState();
  }
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final _selectedGenres = <String>{};
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  String _searchQuery = '';
  final storage = const FlutterSecureStorage();

  List<String> get _filteredGenres {
    return genres
        .where(
            (genre) => genre.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> _logout() async {
    // Remove the access token from the secure storage
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'access_token');

    // Navigate the user back to the AuthScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => const AuthScreen(),
      ),
    );

    _showSuccessSnackBar("Successfully logged out.");
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 71, 200, 71),
      ),
    );
  }

  String getBackendUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000';
    } else {
      return 'http://localhost:8000';
    }

    // return 'http://192.168.178.57:8000';

    // return 'http://18.135.170.219:80';
  }

  Future<void> _savePreferences() async {
    if (_selectedGenres.length < 3) {
      _scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Please select at least 3 genres.'),
          backgroundColor: Color.fromARGB(255, 255, 69, 58),
        ),
      );
      return;
    }

    // Retrieve the Bearer token
    String? token = await storage.read(key: 'access_token');

    if (token != null) {
      final backendUrl = getBackendUrl();

      // Send POST request with the Bearer token and selected preferences
      var response = await http.post(
        Uri.parse('$backendUrl/user/book_preferences'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'preferences': _selectedGenres.toList()}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle successful response
        _scaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(
            content: Text('Preferences saved successfully.'),
            backgroundColor: Color.fromARGB(255, 71, 200, 71),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CameraScreen()),
        );
      } else {
        // Handle error response
        // Show an error message or perform other actions as needed
      }
    } else {
      // Handle the case when the token is not available
      // Show an error message or navigate to the login screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
            title: const Text("Set Book Preferences"),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                  onPressed: _logout,
                  tooltip: "Logout",
                  icon: const Icon(Icons.logout))
            ]),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.secondary, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Below is a list of all available book genres. Feel free to select at least 3 preferences, as this will help us recommend books that fit your style best. You can also use the search function to find a genre that suits you.',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(8.0),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: _filteredGenres.length,
                    itemBuilder: (context, index) {
                      final genre = _filteredGenres[index];
                      return CheckboxListTile(
                        title: Text(genre),
                        value: _selectedGenres.contains(genre),
                        onChanged: (selected) {
                          setState(() {
                            if (selected ?? false) {
                              _selectedGenres.add(genre);
                            } else {
                              _selectedGenres.remove(genre);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(14.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _savePreferences,
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Save Preferences'),
            ),
          ),
        ),
      ),
    );
  }
}
