import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:asesmen_ners/Services/Api.dart';

class AsesmenPage extends StatefulWidget {
  final String studentName;

  const AsesmenPage(this.studentName, {super.key});
  @override
  _AsesmenPageState createState() => _AsesmenPageState();
}

class _AsesmenPageState extends State<AsesmenPage> {
  String _mySelection = '';
  List<dynamic> _studentDatas = []; //edited line
  late Future<List<dynamic>> _studentsFuture;

  _loadUserToken() async {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');
    return accessToken;
  }

  void fetchStudent() async {
    final token = await _loadUserToken(); // Mendapatkan token
    // Header untuk permintaan HTTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print('fetch mahasiswa ${Api.host}/mahasiswa');

    print(headers);
    final response =
        await http.get(Uri.parse('${Api.host}/mahasiswa'), headers: headers);

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      final List<dynamic> data = res['data'];

      setState(() {
        _studentDatas = data;
      });
    } else {
      throw Exception('Failed to load courses');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStudent();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          title: Text('Asesmen'),
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
              key: formKey,
              child: Column(children: [
                DropdownButton(
                  items: _studentDatas.map((item) {
                    return DropdownMenuItem(
                      value: item['id'].toString(),
                      child: Text('${item['npm']} - ${item['nama']}'),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      _mySelection = newVal!;
                    });
                  },
                  value: _mySelection,
                )
              ])),
        ));
  }
}
