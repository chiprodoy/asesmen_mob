import 'dart:convert';
import 'package:asesmen_ners/AsesmenPage.dart';
import 'package:asesmen_ners/Model/Course.dart';
import 'package:asesmen_ners/Services/Api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'LoginPage.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  Future<List<Course>> _coursesFuture = getCourses();
  var token = '';

  @override
  void initState() {
    super.initState();
    _isAuthenticated();
  }

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

  static Future<List<Course>> getCourses() async {
    final token = await _loadUserToken(); // Mendapatkan token
    // Header untuk permintaan HTTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    // print(headers);
    final response =
        await http.get(Uri.parse('${Api.host}/matakuliah'), headers: headers);

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      print(res['data']);
      final List data = res['data'];
      return data.map((e) => Course.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  static _loadUserToken() async {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');
    return accessToken;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pilih Mata Kuliah'),
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder<List<Course>>(
            future: _coursesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                final courses = snapshot.data!;
                return buildCourseListView(courses);
              } else {
                return const Text("No data available");
              }
            },
          ),
        ));
  }

  Widget buildCourseListView(List<Course> courses) {
    return ListView.separated(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return ListTile(
          title: Text(course.namaMataKuliah!),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AsesmenPage(courses[index].uuid)),
            );
          }, // Handle your onTap here.
        );
      },
      separatorBuilder: (context, index) {
        // <-- SEE HERE
        return const Divider();
      },
    );
  }
}
