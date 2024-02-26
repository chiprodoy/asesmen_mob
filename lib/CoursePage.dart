import 'dart:convert';
import 'package:asesmen_ners/Services/Api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'StudentPage.dart';


class CoursePage extends StatefulWidget {
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  late Future<List<String>> _coursesFuture;
  var token = '';

  @override
  void initState() {
    super.initState();
    _coursesFuture = fetchCourses();
  }
  
  _loadUserToken() async{
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');
    return accessToken;
  }




  Future<List<String>> fetchCourses() async {
    final token = await _loadUserToken(); // Mendapatkan token
        // Header untuk permintaan HTTP
    Map<String, String> headers = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
    };
    print(headers);
    final response = await http.get(
      Uri.parse('${Api.host}/matakuliah'),
      headers: headers
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      print(res['data']);
      final List<dynamic> data = res['data'];
      List<String> courses = [];
      data.forEach((course) {
        courses.add(course['nama_mata_kuliah']);
      });
      return courses;
    } else {
      throw Exception('Failed to load courses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Mata Kuliah'),
      ),
      body: Container( 
        padding: EdgeInsets.all(20.0), 
        child:FutureBuilder<List<String>>(
        future: _coursesFuture,
        builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return _buildCourseCard(snapshot.data![index],'',context);
                },
              );
            }
        },
      ),
    ));
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
}
