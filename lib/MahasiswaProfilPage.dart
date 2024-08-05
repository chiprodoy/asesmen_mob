import 'dart:convert';

import 'package:asesmen_ners/LoginPage.dart';
import 'package:asesmen_ners/Model/Dosen.dart';
import 'package:asesmen_ners/Services/Api.dart';
import 'package:asesmen_ners/LandingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class MahasiswaProfilPage extends StatefulWidget {
  @override
  _MahasiswaProfilPageState createState() => _MahasiswaProfilPageState();
}

class _MahasiswaProfilPageState extends State<MahasiswaProfilPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _npmController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
    _isAuthenticated();
  }

  _isAuthenticated() async {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');
    final role = await storage.read(key: 'role_name');

    if (role != 'mahasiswa') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  _loadUserToken() async {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');
    return accessToken;
  }

  Future<void> _fetchProfileData() async {
    final token = await _loadUserToken(); // Mendapatkan token
    // Header untuk permintaan HTTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response =
        await http.get(Uri.parse('${Api.host}/profile'), headers: headers);

    if (response.statusCode == 200) {
      final datas = json.decode(response.body);
      final data = datas['data'][0];
      print('profile data : ');
      print(data['user']);
      setState(() {
        _nameController.text = data['nama'];
        _npmController.text = data['user']['nidn_npm'];
        _emailController.text = data['user']['email'];
        _teleponController.text = data['user']['telepon'];
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<void> _saveProfileData() async {
    setState(() {
      _isLoading = true;
    });
    print('saveprofiledata');

    final token = await _loadUserToken(); // Mendapatkan token

    // Header untuk permintaan HTTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.put(
      Uri.parse('${Api.host}/mahasiswa'),
      headers: headers,
      body: jsonEncode(<String, String>{
        'nama': _nameController.text,
        'npm': _npmController.text,
        'email': _emailController.text,
        'telepon': _teleponController.text
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      _dialogBuilder(context, 'Updating Profile', 'Berhasil mengubah data',
          type: 'success');
    } else {
      print('update mahasiswa failed');
      print(response.statusCode);
      print(response.body);
      final datas = json.decode(response.body);

      _dialogBuilder(context, 'Updating Profile',
          'Gagal mengubah data ${datas['message']}',
          type: 'failed');
    }
  }

  Future<void> _deleteProfileData() async {
    setState(() {
      _isLoading = true;
    });
    print('deleteprofiledata');

    final token = await _loadUserToken(); // Mendapatkan token

    // Header untuk permintaan HTTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.delete(
      Uri.parse('${Api.host}/profile'),
      headers: headers,
    );
    print(response.body);
    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      const storage = FlutterSecureStorage();
      await storage.deleteAll();

      _profileDeletedDialogBuilder(
          context, 'Delete Profile', 'Berhasil menghapus profile',
          type: 'success');
    } else {
      _profileDeletedDialogBuilder(
          context, 'Updating Profile', 'Gagal menghapus profile',
          type: 'failed');
    }
  }

  Future<void> _profileDeletedDialogBuilder(
      BuildContext context, titleMsg, textMsg,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );

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
        title: Text('Edit Profile'),
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
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Nama'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'nama harus diisi';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _npmController,
                      decoration: InputDecoration(labelText: 'NPM'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'npm harus diisi';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'email harus diisi';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _teleponController,
                      decoration: InputDecoration(labelText: 'Telepon'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Telepon harus diisi';
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
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _deleteProfileData();
                        }
                      },
                      child: Text('Hapus Profile'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
