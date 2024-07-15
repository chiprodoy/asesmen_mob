import 'dart:convert';

import 'package:asesmen_ners/LoginPage.dart';
import 'package:asesmen_ners/Model/Dosen.dart';
import 'package:asesmen_ners/Services/Api.dart';
import 'package:asesmen_ners/LandingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class MahasiswaChangePasswordPage extends StatefulWidget {
  const MahasiswaChangePasswordPage({super.key});

  @override
  _MahasiswaChangePasswordPageState createState() =>
      _MahasiswaChangePasswordPageState();
}

class _MahasiswaChangePasswordPageState
    extends State<MahasiswaChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  _loadUserToken() async {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');
    return accessToken;
  }

  Future<void> _saveProfileData() async {
    setState(() {
      _isLoading = true;
    });
    print('save change password');

    final token = await _loadUserToken(); // Mendapatkan token

    // Header untuk permintaan HTTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse('${Api.host}/profile/reset_password'),
      headers: headers,
      body:
          jsonEncode(<String, String>{'password': _newPasswordController.text}),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      _dialogBuilder(context, 'Updating Password', 'Berhasil mengubah password',
          type: 'success');
    } else {
      print('update password failed');
      print(response.statusCode);
      print(response.body);
      final datas = json.decode(response.body);

      _dialogBuilder(context, 'Updating Password',
          'Gagal mengubah data ${datas['message']}',
          type: 'failed');
    }
  }

  Future<void> _dialogBuilder(BuildContext context, titleMsg, textMsg,
      {String type = 'success'}) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titleMsg),
          content: Text(textMsg),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ok'),
              onPressed: () {
                if (type == 'success') {
                  Navigator.pop(context);

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const LandingPage()),
                  // );
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ganti Password'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      controller: _newPasswordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'password baru harus diisi';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _saveProfileData();
                        }
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
