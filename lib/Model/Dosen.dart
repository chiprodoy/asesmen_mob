import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../Services/Api.dart';

class Dosen {
  int? id;
  String? nidn;
  String? nama;
  String? telepon;
  String? email;
  String? password;

  Dosen({this.id, this.nidn, this.nama});

  Dosen.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nidn = json['nidn'];
    nama = json['nama'];
  }

  _loadUserToken() async {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');
    return accessToken;
  }

  Future<bool> store() async {
    final token = await _loadUserToken(); // Mendapatkan token
    print(token);
    // Header untuk permintaan HTTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    // print(headers);
    print('${Api.host}/dosen');
    print(
        'nidn: ${this.nidn} nama: ${this.nama}, telepon: ${this.telepon}, email: ${this.email}');

    final response = await http.post(Uri.parse('${Api.host}/dosen'),
        headers: headers,
        body: jsonEncode({
          "nidn": this.nidn,
          "nama": this.nama,
          "telepon": this.telepon,
          "email": this.email,
          "password": this.password
        }));

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      print(res['data']);
      final List data = res['data'];
      return true;
    } else {
      print(response.statusCode);
      print(response.body);
      return false;
    }
  }
}
