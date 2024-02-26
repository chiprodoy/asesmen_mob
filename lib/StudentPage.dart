import 'package:asesmen_ners/AsesmenPage.dart';
import 'package:flutter/material.dart';

class StudentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mahasiswa'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Selamat Datang, Nama Pengguna',
                    style: TextStyle(fontSize: 12),
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/user_photo.jpg'),
                    radius: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Mahasiswa',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildStudentTile('Mahasiswa 1', context),
                    _buildStudentTile('Mahasiswa 2', context),
                    _buildStudentTile('Mahasiswa 3', context),
                    _buildStudentTile('Mahasiswa 4', context),
                    _buildStudentTile('Mahasiswa 5', context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentTile(String studentName, BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AsesmenPage(studentName)),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(Icons.person),
              SizedBox(width: 10),
              Text(
                studentName,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


