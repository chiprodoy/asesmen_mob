import 'dart:convert';
import 'package:asesmen_ners/KompetensiPage.dart';
import 'package:asesmen_ners/Model/Dosen.dart';
import 'package:asesmen_ners/Model/Kompetensi.dart';
import 'package:asesmen_ners/Model/NilaiSubKompetensi.dart';
import 'package:asesmen_ners/Model/SubKompetensi.dart';
import 'package:asesmen_ners/Services/Api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class SubKompetensiPage extends StatefulWidget {
  final String? kompetensiUUID;
  final Kompetensi kompetensi;
  const SubKompetensiPage(this.kompetensiUUID, this.kompetensi);

  @override
  _SubKompetensiPageState createState() => _SubKompetensiPageState();
}

class PDFViewerFromUrl extends StatelessWidget {
  const PDFViewerFromUrl({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Asesmen'),
      ),
      body: const PDF(swipeHorizontal: true).fromUrl(
        url,
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}

class _SubKompetensiPageState extends State<SubKompetensiPage> {
  late Future<List<SubKompetensi>> _subKompetensisFuture;
  String _selectedMhs = '';
  String _selectedDosen = '';
  String _pembimbingAkademik = '';
  String _pembimbingLapangan = '';
  List<dynamic>? _studentDatas; //edited line
  List<dynamic>? _dosenDatas; //edited line

  var token = '';

  @override
  void initState() {
    super.initState();
    fetchStudent();
    fetchDosen();
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
      throw Exception('Failed to load student');
    }
  }

  void fetchDosen() async {
    final token = await _loadUserToken(); // Mendapatkan token
    // Header untuk permintaan HTTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print('fetch dosen ${Api.host}/dosen');

    final response =
        await http.get(Uri.parse('${Api.host}/dosen'), headers: headers);

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      final List<dynamic> data = res['data'];

      setState(() {
        _dosenDatas = data;
      });
    } else {
      throw Exception('Failed to load dosen');
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
                      dropDownMahasiswa(),
                      inputTextPembimbingAkademik(),
                      inputTextPembimbingLapangan(),
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
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(
                            40), // fromHeight use double.infinity as width and 40 is the height
                      ),
                      onPressed: () =>
                          // Respond to button press
                          Navigator.push(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (_) => PDFViewerFromUrl(
                                  url:
                                      '${Api.host}/asesmen_report/${_selectedMhs}',
                                ),
                              )),
                      child: const Text('Simpan'),
                    )
                  ],
                )
              ],
            )));
  }

  Widget dropDownMahasiswa() {
    return DropdownButton(
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
    );
  }

  Widget inputTextPembimbingAkademik() {
    return TextField(
        onChanged: (value) async {
          setState(() {
            _pembimbingAkademik = value;
          });
        },
        decoration: const InputDecoration(
          hintText: 'Pembimbing Akademik',
          border: OutlineInputBorder(),
        ));
  }

  Widget inputTextPembimbingLapangan() {
    return TextField(
        onChanged: (value) async {
          setState(() {
            _pembimbingLapangan = value;
          });
        },
        decoration: const InputDecoration(
          hintText: 'Pembimbing Lapangan',
          border: OutlineInputBorder(),
        ));
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
                    print('_pembimbingAkademik: $_pembimbingAkademik');
                    print('_pembimbingLapangan: $_pembimbingLapangan');

                    NilaiSubKompetensi nilai = NilaiSubKompetensi(
                        1,
                        subKompetensi.id,
                        subKompetensi.uuid,
                        int.parse(_selectedMhs),
                        1,
                        int.parse(inputNilai),
                        _pembimbingAkademik,
                        _pembimbingLapangan);
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
