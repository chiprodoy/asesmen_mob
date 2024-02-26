import 'dart:convert';

import 'package:asesmen_ners/StudentPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:asesmen_ners/Services/Api.dart';

class CoursePageCopy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mata Kuliah'),
          actions: const [
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
              const Text(
                'Daftar Mata Kuliah',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildCourseCard('Course 1', 'Description 1', context),
                    _buildCourseCard('Course 2', 'Description 2', context),
                    _buildCourseCard('Course 3', 'Description 3', context),
                    _buildCourseCard('Course 4', 'Description 4', context),
                    _buildCourseCard('Course 5', 'Description 5', context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(String title, String description, BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StudentPage()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(description),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<String>> fetchCourses() async {
    final response = await http.get(Uri.parse('https://epk.anantatechnology.com/api/matakuliah'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<String> courses = [];
      data.forEach((course) {
        courses.add(course['nama']);
      });
      return courses;
    } else {
      throw Exception('Failed to load courses');
    }
  }
}

