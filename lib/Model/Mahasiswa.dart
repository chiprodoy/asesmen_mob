import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../Services/Api.dart';

class Mahasiswa {
  int? id;
  String? uuid;
  String? npm;
  String? nama;
  String? telepon;
  String? email;

  Mahasiswa(this.id, this.npm, this.nama, this.telepon, this.email);

  Mahasiswa.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    nama = json['nama'];
    npm = json['npm'];
    telepon = json['user']['telepon'];
    email = json['user']['email'];
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
    print('${Api.host}/mahasiswa');
    print(
        'npm: ${this.npm} nama: ${this.nama}, telepon: ${this.telepon},email: ${this.email}');

    try {
      final response = await http.post(Uri.parse('${Api.host}/mahasiswa'),
          headers: headers,
          body: jsonEncode({
            "npm": this.npm,
            "nama": this.nama,
            "telepon": this.telepon,
            "email": this.email
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
    } on Exception catch (exception) {
      print(exception.toString());

      return false;
    } catch (error) {
      print(error.toString());

      return false;
    }
  }

  Future<bool> update() async {
    final token = await _loadUserToken(); // Mendapatkan token
    // Header untuk permintaan HTTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    // print(headers);
    print('${Api.host}/mahasiswa');
    print(
        'npm: ${this.npm} nama: ${this.nama}, telepon: ${this.telepon},email: ${this.email}');

    try {
      final response = await http.put(
          Uri.parse('${Api.host}/mahasiswa/${this.id}'),
          headers: headers,
          body: jsonEncode({
            "npm": this.npm,
            "nama": this.nama,
            "telepon": this.telepon,
            "email": this.email
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
    } on Exception catch (exception) {
      print(exception.toString());

      return false;
    } catch (error) {
      print(error.toString());

      return false;
    }
  }
}
