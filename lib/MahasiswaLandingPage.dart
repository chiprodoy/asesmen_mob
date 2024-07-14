import 'package:asesmen_ners/CoursePage.dart';
import 'package:asesmen_ners/LoginPage.dart';
import 'package:asesmen_ners/MahasiswaCoursePage.dart';
import 'package:asesmen_ners/MahasiswaProfilPage.dart';
import 'package:asesmen_ners/StudentPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MahasiswaLandingPage extends StatelessWidget {
  const MahasiswaLandingPage({super.key});

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
                      _buildCard(Icons.rate_review, 'Hasil Penilaian', () {
                        // Tindakan saat card form penilaian diklik
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MahasiswaCoursePage(),
                          ),
                        );
                      }),
                      _buildCard(Icons.manage_accounts, ' Profil', () {
                        // Tindakan saat card import mahasiswa diklik
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MahasiswaProfilPage(),
                          ),
                        );
                      }),
                      _buildCard(Icons.logout, ' Logout', () {
                        const storage = FlutterSecureStorage();
                        storage.deleteAll();
                        // Tindakan saat card import mahasiswa diklik
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
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
