import 'dart:convert';
//import 'package:asesmen_ners/KompetensiPage.dar';
import 'package:asesmen_ners/LoginPage.dart';
import 'package:asesmen_ners/Model/Mahasiswa.dart';
import 'package:asesmen_ners/Services/Api.dart';
import 'package:asesmen_ners/StudentPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class StudentCreatePage extends StatefulWidget {
  const StudentCreatePage({super.key});

  // final Kompetensi kompetensi;

  @override
  _StudentCreatePageState createState() => _StudentCreatePageState();
}

class _StudentCreatePageState extends State<StudentCreatePage> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // A key for managing the form
  int _id = 0;
  String _nama = '';
  String _npm = '';
  String _telepon = '';
  String _email = '';

  late Future<List<Mahasiswa>> _mahasiswaFuture;
  List<dynamic>? _studentDatas; //edited line

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
        appBar: AppBar(title: const Text('Mahasiswa')),
        body: Form(
          key: _formKey, // Associate the form key with this Form widget
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Nama'), // Label for the name field
                  validator: (value) {
                    // Validation function for the name field
                    if (value!.isEmpty) {
                      return 'Nama Mahasiswa tidak boleh kosong'; // Return an error message if the name is empty
                    }
                    return null; // Return null if the name is valid
                  },
                  onSaved: (value) {
                    _nama = value!; // Save the entered name
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'NPM'), // Label for the name field
                  validator: (value) {
                    // Validation function for the name field
                    if (value!.isEmpty) {
                      return 'Npm tidak boleh kosong'; // Return an error message if the name is empty
                    }
                    return null; // Return null if the name is valid
                  },
                  onSaved: (value) {
                    _npm = value!; // Save the entered name
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Email'), // Label for the email field
                  validator: (value) {
                    // Validation function for the email field
                    if (value!.isEmpty) {
                      return 'email tidak boleh kosong.'; // Return an error message if the email is empty
                    }
                    // You can add more complex validation logic here
                    return null; // Return null if the email is valid
                  },
                  onSaved: (value) {
                    _email = value!; // Save the entered email
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'No Hp'), // Label for the email field
                  validator: (value) {
                    // Validation function for the email field
                    if (value!.isEmpty) {
                      return 'nomor hp tidak boleh kosong.'; // Return an error message if the email is empty
                    }
                    // You can add more complex validation logic here
                    return null; // Return null if the email is valid
                  },
                  onSaved: (value) {
                    _telepon = value!; // Save the entered email
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed:
                      _submitForm, // Call the _submitForm function when the button is pressed
                  child: Text('Submit'), // Text on the button
                ),
              ],
            ),
          ),
        ));
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
        );
      },
      separatorBuilder: (context, index) {
        // <-- SEE HERE
        return const Divider();
      },
    );
  }

  Future<void> _submitForm() async {
    // Check if the form is valid
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save the form data
      Mahasiswa mahasiswa = Mahasiswa(_id, _npm, _nama, _telepon, _email);
      if (await mahasiswa.store()) {
        AlertDialog alert = AlertDialog(
          title: const Text('Berhasil'),
          content: const Text('Mahasiswa Berhasil disimpan'),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentPage()),
                ).then((value) => setState(() {}));
              },
            ),
          ],
        );
        showDialog(context: context, builder: (context) => alert);
        return;
      } else {
        AlertDialog alert = AlertDialog(
          title: const Text('Gagal'),
          content: const Text('Mahasiswa gagal disimpan'),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            ),
          ],
        );
        showDialog(context: context, builder: (context) => alert);
        return;
      }
      // You can perform actions with the form data here and extract the details
    }
  }
}
