import 'dart:convert';
//import 'package:asesmen_ners/KompetensiPage.dar';
import 'package:asesmen_ners/Model/Mahasiswa.dart';
import 'package:asesmen_ners/Services/Api.dart';
import 'package:asesmen_ners/StudentCreatePage.dart';
import 'package:asesmen_ners/StudentEditPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  // final Kompetensi kompetensi;

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  late Future<List<Mahasiswa>> _mahasiswaFuture;
  List<dynamic>? _studentDatas; //edited line
  var token = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  Future<List<Mahasiswa>> getStudents() async {
    final token = await _loadUserToken(); // Mendapatkan token
    // Header untuk permintaan HTTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response =
        await http.get(Uri.parse('${Api.host}/mahasiswa'), headers: headers);

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      print(res['data']);
      final List data = res['data'];
      return data.map((e) => Mahasiswa.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load mahasiswa');
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
        appBar: AppBar(title: const Text('Mahasiswa')),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: buildMahasiswaFuture(),
                ),
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(
                            40), // fromHeight use double.infinity as width and 40 is the height
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StudentCreatePage()),
                      ),
                      child: const Text('Tambah'),
                    )
                  ],
                )
              ],
            )));
  }

  FutureBuilder buildMahasiswaFuture() {
    return FutureBuilder<List<Mahasiswa>>(
      future: getStudents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 5.0,
            width: 5.0,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          final datas = snapshot.data!;
          return buildStudentListView(datas);
        } else {
          return const Text("No data available");
        }
      },
    );
  }

  Widget buildStudentListView(List<Mahasiswa> mahasiswas) {
    return ListView.separated(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: mahasiswas.length,
      itemBuilder: (context, index) {
        final mahasiswa = mahasiswas[index];
        return ListTile(
          title: Text(mahasiswa.nama!),
          onTap: () {
            print('list view on tap:');
            print('npm ${mahasiswa.npm}');
            print('nama ${mahasiswa.nama}');
            print('telepon ${mahasiswa.telepon}');
            print('email ${mahasiswa.email}');

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentEditPage(
                  id: mahasiswa.id.toString(),
                  npm: mahasiswa.npm!,
                  nama: mahasiswa.nama!,
                  telepon: mahasiswa.telepon!,
                  email: mahasiswa.email!,
                ),
              ),
            );
          },
        );
      },
      separatorBuilder: (context, index) {
        // <-- SEE HERE
        return const Divider();
      },
    );
  }
}
