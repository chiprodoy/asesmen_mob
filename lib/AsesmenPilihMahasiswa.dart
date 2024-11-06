import 'dart:convert';

import 'package:asesmen_ners/Model/Mahasiswa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'DownloadPDFPage.dart';
import 'Services/Api.dart';

class AsesmenPilihMahasiswaPage extends StatelessWidget {
  final int? itemName;

  // Konstruktor menerima parameter itemName
  AsesmenPilihMahasiswaPage({this.itemName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pilih Mahasiswa"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text("Silakan pilih mahasiswa"),
            // Contoh daftar mahasiswa
            Expanded(
              child: FutureBuilder<List<Mahasiswa>>(
                future: getMahasiswas(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                      "Sedang Memuat Halaman.....",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final datas = snapshot.data!;
                    return buildMahasiswaListView(datas);
                  } else {
                    return const Text("No data available");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loadUserToken() async {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');
    return accessToken;
  }

  Future<List<Mahasiswa>> getMahasiswas() async {
    final token = await _loadUserToken(); // Mendapatkan token
    // Header untuk permintaan HTTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    // print(headers);
    print('${Api.host}/mahasiswa/');

    final response =
        await http.get(Uri.parse('${Api.host}/mahasiswa'), headers: headers);

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      print('assesmen-pilih-mahasiswa: ${res['data']}');
      print(res['data']);
      final List data = res['data'];
      return data.map((e) => Mahasiswa.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load asesmen');
    }
  }

  Widget buildMahasiswaListView(List<Mahasiswa> mahasiswas) {
    return ListView.separated(
      itemCount: mahasiswas.length,
      itemBuilder: (context, index) {
        final mahasiswa = mahasiswas[index];
        //print('sumber nilai1: ${asesmen.uuid}');
        return ListTile(
          title: Text(mahasiswa.nama!),
          subtitle: Text(mahasiswa.npm!),

          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute<dynamic>(
                    builder: (_) => DownloadPDFPage(
                        url:
                            '${Api.host}/asesmen_report/${mahasiswa.id}/${itemName!}')));
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
