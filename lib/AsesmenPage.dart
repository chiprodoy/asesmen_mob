import 'dart:convert';
//import 'package:asesmen_ners/KompetensiPage.dar';
import 'package:asesmen_ners/Model/Asesmen.dart';
import 'package:asesmen_ners/Services/Api.dart';
import 'package:asesmen_ners/SideMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'LoginPage.dart';
import 'StudentPage.dart';
import 'SubKompetensiPage.dart';

class AsesmenPage extends StatefulWidget {
  final String? matakuliahUUID;
  const AsesmenPage(this.matakuliahUUID);

  @override
  _AsesmenPageState createState() => _AsesmenPageState();
}

class _AsesmenPageState extends State<AsesmenPage> {
  late Future<List<Asesmen>> _asesmensFuture;
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

  Future<List<Asesmen>> getAsesmens(courseUUId) async {
    final token = await _loadUserToken(); // Mendapatkan token
    // Header untuk permintaan HTTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    // print(headers);
    print('cuuid: ' + widget.matakuliahUUID!);
    print('${Api.host}/asesmen/${widget.matakuliahUUID}');

    final response = await http.get(
        Uri.parse('${Api.host}/asesmen/${widget.matakuliahUUID}'),
        headers: headers);

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      print('asesmen: ${res['data']}');
      print(res['data']);
      final List data = res['data'];
      return data.map((e) => Asesmen.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load asesmen');
    }
  }

  _loadUserToken() async {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');
    return accessToken;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pilih Asesmen'),
        ),
        endDrawer: SideMenu(),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder<List<Asesmen>>(
            future: getAsesmens(widget.matakuliahUUID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                final datas = snapshot.data!;
                return buildAsesmenListView(datas);
              } else {
                return const Text("No data available");
              }
            },
          ),
        ));
  }

  Widget buildAsesmenListView(List<Asesmen> asesmens) {
    return ListView.separated(
      itemCount: asesmens.length,
      itemBuilder: (context, index) {
        final asesmen = asesmens[index];
        print('sumber nilai1: ${asesmen.sumberNilai1}');
        return ListTile(
          title: Text(asesmen.namaAsesmen!),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SubKompetensiPage(asesmen.uuid,
                      asesmen.id, asesmen.sumberNilai1, asesmen.sumberNilai2)),
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
