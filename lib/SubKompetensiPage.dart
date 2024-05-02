import 'dart:convert';
import 'package:asesmen_ners/KompetensiPage.dart';
import 'package:asesmen_ners/Model/Kompetensi.dart';
import 'package:asesmen_ners/Model/NilaiSubKompetensi.dart';
import 'package:asesmen_ners/Model/SubKompetensi.dart';
import 'package:asesmen_ners/Services/Api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SubKompetensiPage extends StatefulWidget {
  final String? kompetensiUUID;
  final Kompetensi kompetensi;
  const SubKompetensiPage(this.kompetensiUUID, this.kompetensi);

  @override
  _SubKompetensiPageState createState() => _SubKompetensiPageState();
}

class _SubKompetensiPageState extends State<SubKompetensiPage> {
  late Future<List<SubKompetensi>> _subKompetensisFuture;
  String _selectedMhs = '';
  List<dynamic>? _studentDatas; //edited line
  var token = '';

  @override
  void initState() {
    super.initState();
    fetchStudent();
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

  Future<List<SubKompetensi>> getSubKompetensis() async {
    final token = await _loadUserToken(); // Mendapatkan token
    // Header untuk permintaan HTTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    // print(headers);
    print('cuuid: ${widget.kompetensiUUID!}');
    print('${Api.host}/subkompetensi/${widget.kompetensiUUID}');

    final response = await http.get(
        Uri.parse('${Api.host}/subkompetensi/${widget.kompetensiUUID}'),
        headers: headers);

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      print(res['data']);
      final List data = res['data'];
      return data.map((e) => SubKompetensi.fromJson(e)).toList();
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
          title: const Text('Pilih SubKompetensi'),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Column(
                    // set the height of the header container as needed
                    children: <Widget>[
                      DropdownButton(
                        hint: const Text('Pilih Mahasiswa'),
                        isExpanded: true,
                        items: _studentDatas?.map((item) {
                          return DropdownMenuItem(
                              value: item['id'].toString(),
                              child: Text('${item['npm']} - ${item['nama']}'));
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            _selectedMhs = newVal!;
                          });
                        },
                        value: _selectedMhs.isEmpty ? null : _selectedMhs,
                      ),
                      Text(widget.kompetensi.namaKompetensi!)
                    ]),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: FutureBuilder<List<SubKompetensi>>(
                    future: getSubKompetensis(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        final datas = snapshot.data!;
                        return buildSubKompetensiListView(datas);
                      } else {
                        return const Text("No data available");
                      }
                    },
                  ),
                ),
                // Column(
                //   children: [
                //     ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //         minimumSize: const Size.fromHeight(
                //             40), // fromHeight use double.infinity as width and 40 is the height
                //       ),
                //       onPressed: () {
                //         // Respond to button press
                //       },
                //       child: const Text('Simpan'),
                //     )
                //   ],
                // )
              ],
            )));
  }

  Widget buildSubKompetensiListView(List<SubKompetensi> subKompetensis) {
    return ListView.separated(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: subKompetensis.length,
      itemBuilder: (context, index) {
        final subKompetensi = subKompetensis[index];
        return ListTile(
          title: Text(subKompetensi.namaSubKompetensi!),
          trailing: SizedBox(
              width: 30,
              child: TextField(
                  onChanged: (inputNilai) async {
                    print('_selectedMhs: $_selectedMhs');
                    print('subKompetensi id: ${subKompetensi.id}');
                    print('inputNilai: $inputNilai');

                    NilaiSubKompetensi nilai = NilaiSubKompetensi(
                        1,
                        subKompetensi.id,
                        subKompetensi.uuid,
                        int.parse(_selectedMhs),
                        1,
                        int.parse(inputNilai));
                    bool nilaiHasStored = await nilai.store();
                    if (nilaiHasStored) {
                      const SnackBar(content: Text('Data Berhasil Disimpan'));
                    } else {
                      const SnackBar(content: Text('Data Gagal Disimpan'));
                    }
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.all(8)))),
        );
      },
      separatorBuilder: (context, index) {
        // <-- SEE HERE
        return const Divider();
      },
    );
  }
}
