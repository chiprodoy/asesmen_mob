import 'dart:convert';
import 'package:asesmen_ners/Services/Api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'StudentPage.dart';

class AsesmenPage extends StatefulWidget {
  final String matakuliahUUID = '';
  const AsesmenPage(matakuliahUUID, {super.key});

  @override
  _AsesmenPageState createState() => _AsesmenPageState();
}

class _AsesmenPageState extends State<AsesmenPage> {
  late Future<List<String>> _asesmensFuture;
  var token = '';

  @override
  void initState() {
    super.initState();
    _asesmensFuture = fetchAsesmens();
  }

  _loadUserToken() async {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');
    return accessToken;
  }

  Future<List<String>> fetchAsesmens() async {
    final token = await _loadUserToken(); // Mendapatkan token
    // Header untuk permintaan HTTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print(headers);
    final response =
        await http.get(Uri.parse('${Api.host}/asesmen'), headers: headers);

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      print(res['data']);
      final List<dynamic> data = res['data'];
      List<String> Asesmens = [];
      for (var Asesmen in data) {
        Asesmens.add(Asesmen['nama_mata_kuliah']);
      }
      return Asesmens;
    } else {
      throw Exception('Failed to load Asesmens');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pilih Mata Kuliah'),
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder<List<String>>(
            future: _asesmensFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return _buildAsesmenCard(
                        snapshot.data![index], '', context);
                  },
                );
              }
            },
          ),
        ));
  }

  Widget _buildAsesmenCard(
      String title, String description, BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StudentPage()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
