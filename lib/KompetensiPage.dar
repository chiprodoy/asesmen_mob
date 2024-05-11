import 'dart:convert';
import 'package:asesmen_ners/Services/Api.dart';
import 'package:asesmen_ners/SubKompetensiPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'Model/Kompetensi.dart';
import 'StudentPage.dart';

class KompetensiPage extends StatefulWidget {
  final String? asesmenUUID;
  const KompetensiPage(this.asesmenUUID);

  @override
  _KompetensiPageState createState() => _KompetensiPageState();
}

class _KompetensiPageState extends State<KompetensiPage> {
  late Future<List<Kompetensi>> _kompetensisFuture;
  var token = '';

  Future<List<Kompetensi>> getKompetensis() async {
    final token = await _loadUserToken(); // Mendapatkan token
    // Header untuk permintaan HTTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    // print(headers);
    print('cuuid: ' + widget.asesmenUUID!);
    print('${Api.host}/kompetensi/${widget.asesmenUUID}');

    final response = await http.get(
        Uri.parse('${Api.host}/kompetensi/${widget.asesmenUUID}'),
        headers: headers);

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      //print(res['data']);
      final List data = res['data'];

      return data.map((e) => Kompetensi.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load kompetensi');
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
          title: const Text('Pilih Kompetensi'),
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder<List<Kompetensi>>(
            future: getKompetensis(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                final datas = snapshot.data!;
                return buildKompetensiListView(datas);
              } else {
                return const Text("No data available");
              }
            },
          ),
        ));
  }

  Widget buildKompetensiListView(List<Kompetensi> kompetensis) {
    return ListView.separated(
      itemCount: kompetensis.length,
      itemBuilder: (context, index) {
        final kompetensi = kompetensis[index];
        print(kompetensi.namaKompetensi);
        return ListTile(
          title: Text(kompetensi.namaKompetensi!),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SubKompetensiPage(kompetensi.uuid, kompetensi)),
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
