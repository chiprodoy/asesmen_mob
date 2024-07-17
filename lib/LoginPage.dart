import 'dart:convert';

import 'package:asesmen_ners/MahasiswaLandingPage.dart';
import 'package:asesmen_ners/Services/Api.dart';
import 'package:asesmen_ners/LandingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'RegisterPage.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
          child: const Center(
            child: SingleChildScrollView(
              child: LoginForm(),
            ),
          ),
        ),
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
  String email = '';
  String password = '';
  MaterialPageRoute _pageRoute =
      MaterialPageRoute(builder: (context) => const MahasiswaLandingPage());

  Future<String> _getUserRoleName() async {
    final storage = FlutterSecureStorage();

    String role_name = '';
    role_name = (await storage.read(key: 'role_name'))!;

    return role_name;
  }

  MaterialPageRoute _drawLandingPage() {
    _getUserRoleName().then((value) {
      if (value == 'dosen') {
        setState(() {
          _pageRoute =
              MaterialPageRoute(builder: (context) => const LandingPage());
        });
        //print('landingpage');
      } else if (value == 'mahasiswa') {
        setState(() {
          _pageRoute = MaterialPageRoute(
              builder: (context) => const MahasiswaLandingPage());
        });
      }
    });
    return _pageRoute;

    // if (_role == 'dosen') {
    //   return MaterialPageRoute(builder: (context) => const LandingPage());
    // }

    // return MaterialPageRoute(
    //     builder: (context) => const MahasiswaLandingPage());
  }

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
        // print(data['data']['token']);
        // print(data['data']['user  ']);

        // Autentikasi berhasil, lakukan tindakan selanjutnya

        const storage = FlutterSecureStorage();
        await storage.write(key: 'access_token', value: data['data']['token']);
        await storage.write(
            key: 'user_id', value: data['data']['user']['id'].toString());
        await storage.write(
            key: 'role_name',
            value: data['data']['user']['roles'][0]['role_name']);
        //print(await storage.readAll());

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
          return alert('Login gagal', 'Terjadi kesalahan: $error');
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
            Image.asset(
              'assets/images/logo.png',
              width: size.width * 0.7,
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Username tidak boleh kosong';
                }
                email = value;
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Username',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                password = value;
                return null;
              },
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock),
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
                        var isAuthenticated =
                            await _authenticate(email, password);
                        if (isAuthenticated) {
                          _getUserRoleName().then((value) {
                            if (value == 'dosen') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LandingPage()),
                              );
                            } else if (value == 'mahasiswa') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MahasiswaLandingPage()),
                              );
                            }
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Autentikasi Gagal')),
                          );
                        }

                        // Lakukan autentikasi atau tindakan lain di sini
                      }
                    },
                    child: Text(_isLoading ? 'Proccessing..' : 'Login'),
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
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text('Buat Akun'),
            ),
          ],
        ),
      ),
    );
  }
}
