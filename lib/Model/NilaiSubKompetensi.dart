import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../Services/Api.dart';

class NilaiSubKompetensi {
  int? id;
  int? subKompetensiID;
  String? subKompetensiUUID;
  int? mahasiswaID;
  int? dosenID;
  int? nilai;
  String? pembimbingAkademik;
  String? pembimbingLapangan;

  NilaiSubKompetensi(
      this.id,
      this.subKompetensiID,
      this.subKompetensiUUID,
      this.mahasiswaID,
      this.dosenID,
      this.nilai,
      this.pembimbingAkademik,
      this.pembimbingLapangan);

  NilaiSubKompetensi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subKompetensiID = json['sub_kompetensi_id'];
    mahasiswaID = json['mahasiswa_id'];
    dosenID = json['dosen_id'];
    nilai = json['nilai'];
    pembimbingAkademik = json['pembimbing_akademik'];
    pembimbingLapangan = json['pembimbing_lapangan'];
  }

  _loadUserToken() async {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');
    return accessToken;
  }

  Future<bool> store() async {
    final token = await _loadUserToken(); // Mendapatkan token
    // Header untuk permintaan HTTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    // print(headers);
    print('cuuid: ${this.subKompetensiUUID!}');
    print('${Api.host}/nilai_subkompetensi/${this.subKompetensiUUID}');

    final response = await http.post(
        Uri.parse('${Api.host}/nilai_subkompetensi/${this.subKompetensiUUID}'),
        headers: headers,
        body: jsonEncode({
          "mahasiswa_id": this.mahasiswaID,
          "nilai": this.nilai,
          "pembimbing_akademik": this.pembimbingAkademik,
          "pembimbing_lapangan": this.pembimbingLapangan
        }));

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      print(res['data']);
      final List data = res['data'];
      return true;
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to store nilai');
    }
  }
}
