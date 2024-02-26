import 'package:asesmen_ners/CoursePage.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.person, color: Colors.white, size: 30),
                    SizedBox(width: 10),
                    Text(
                      'Selamat Datang, Nama Pengguna',
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
                      _buildCard(Icons.book, 'Kurikulum', () {
                        // Tindakan saat card kurikulum diklik
                      }),
                      _buildCard(Icons.menu_book, 'Mata Kuliah', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoursePage(),
                          ),
                        );
                      }),
                      _buildCard(Icons.rate_review, 'Form Penilaian', () {
                        // Tindakan saat card form penilaian diklik
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoursePage(),
                          ),
                        );
                      }),
                      _buildCard(Icons.people, 'Import Mahasiswa', () {
                        // Tindakan saat card import mahasiswa diklik
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImportMahasiswaPage(),
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
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}


class ImportMahasiswaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Import Mahasiswa Page'),
      ),
      body: Center(
        child: Text('This is the Import Mahasiswa Page'),
      ),
    );
  }
}
