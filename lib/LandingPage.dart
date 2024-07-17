import 'package:asesmen_ners/CoursePage.dart';
import 'package:asesmen_ners/DosenChangePasswordPage.dart';
import 'package:asesmen_ners/LoginPage.dart';
import 'package:asesmen_ners/StudentPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'ProfilPage.dart';
import 'Services/Api.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  _isAuthenticated() async {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');
    final role = await storage.read(key: 'role_name');

    if (role != 'dosen') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _isAuthenticated();
  }

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.person, color: Colors.white, size: 30),
                    SizedBox(width: 10),
                    Text(
                      'Selamat Datang',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    children: [
                      _buildCard(Icons.rate_review, 'Form Penilaian', () {
                        // Tindakan saat card form penilaian diklik
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CoursePage(),
                          ),
                        );
                      }),
                      _buildCard(Icons.people, ' Mahasiswa', () {
                        // Tindakan saat card import mahasiswa diklik
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StudentPage(),
                          ),
                        );
                      }),
                      _buildCard(Icons.manage_accounts, ' Profil', () {
                        // Tindakan saat card import mahasiswa diklik
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilPage(),
                          ),
                        );
                      }),
                      _buildCard(Icons.manage_accounts, ' Ganti Password', () {
                        // Tindakan saat card import mahasiswa diklik
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DosenChangePasswordPage(),
                          ),
                        );
                      }),
                      _buildCard(Icons.logout, ' Logout', () {
                        return _logOut(context);
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  _logOut(BuildContext context) {
    _signOut(context);
    // Tindakan saat card import mahasiswa diklik
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  Future<bool> _signOut(BuildContext context) async {
    // Header untuk permintaan HTTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      // Mengirim permintaan POST ke API
      http.Response response = await http.get(
        Uri.parse('${Api.host}/logout'),
        headers: headers,
      );

      // Memeriksa kode status respons
      if (response.statusCode == 200) {
        // Autentikasi berhasil, lakukan tindakan selanjutnya

        const storage = FlutterSecureStorage();
        await storage.deleteAll();
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
          return alert('Logout gagal', 'Terjadi kesalahan: $error');
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
}

class ImportMahasiswaPage extends StatelessWidget {
  const ImportMahasiswaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Mahasiswa Page'),
      ),
      body: const Center(
        child: Text('This is the Import Mahasiswa Page'),
      ),
    );
  }
}
