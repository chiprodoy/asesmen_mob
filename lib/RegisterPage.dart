import 'dart:convert';

import 'package:asesmen_ners/LoginPage.dart';
import 'package:asesmen_ners/Model/Dosen.dart';
import 'package:asesmen_ners/Services/Api.dart';
import 'package:asesmen_ners/LandingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[400]!, Colors.blue[900]!],
              ),
            ),
            child: const LoginForm()),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _nidn = '';
  String _nama = '';
  String _telepon = '';
  String _email = '';
  String _password = '';

  Future<bool> _authenticate(email, password) async {
    // Data yang akan dikirim dalam body request
    Map<String, String> data = {
      'email': email,
      'password': password,
    };

    // Mengonversi data menjadi format JSON
    String jsonData = json.encode(data);

    // Header untuk permintaan HTTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      // Mengirim permintaan POST ke API
      http.Response response = await http.post(
        Uri.parse('${Api.host}/login'),
        headers: headers,
        body: jsonData,
      );

      // Memeriksa kode status respons
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data['data']['token']);
        // Autentikasi berhasil, lakukan tindakan selanjutnya

        const storage = FlutterSecureStorage();
        await storage.write(key: 'access_token', value: data['data']['token']);
        return true;
      } else {
        // Autentikasi gagal, tampilkan pesan kesalahan
        return false;
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert('Pendaftaran gagal', 'Terjadi kesalahan: $error');
        },
      );
      // Menangani kesalahan yang mungkin terjadi
      return false;
    }
  }

  AlertDialog alert(String title, String message) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {},
    );
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [okButton],
    );
    return alert;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            spreadRadius: 2.0,
            offset: Offset(0.0, 2.0),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20.0),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NIDN tidak boleh kosong';
                }
                _nidn = value;
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'NIDN',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                _nama = value;
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email tidak boleh kosong';
                }
                _email = value;
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'No Telpon tidak boleh kosong';
                }
                _telepon = value;
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'No Telp / Hp',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                _password = value;
                return null;
              },
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        Dosen dosen = Dosen();
                        dosen.nama = _nama;
                        dosen.nidn = _nidn;
                        dosen.email = _email;
                        dosen.telepon = _telepon;
                        dosen.password = _password;
                        var isStoreSuccess = await dosen.store();
                        if (isStoreSuccess) {
                          _dialogBuilder(
                              context, 'Pendaftaran', 'Pendaftaran Berhasil');

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => const LoginPage()),
                          // );
                        } else {
                          _dialogBuilder(
                              context, 'Pendaftaran', 'Pendaftaran Gagal');
                        }

                        // Lakukan autentikasi atau tindakan lain di sini
                      }
                    },
                    child: Text(_isLoading ? 'Proccessing..' : 'Simpan'),
                  );
                },
              ),
            ),
            const SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                // Tindakan untuk tombol lupa password
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, titleMsg, textMsg,
      {String type = 'success'}) {
    return showDialog<void>(
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
}
