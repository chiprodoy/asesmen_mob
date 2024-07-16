import 'dart:convert';
//import 'package:asesmen_ners/KompetensiPage.dar';
import 'package:asesmen_ners/Model/Mahasiswa.dart';
import 'package:asesmen_ners/Services/Api.dart';
import 'package:asesmen_ners/StudentPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class StudentEditPage extends StatefulWidget {
  final String nama;
  final String npm;
  final String telepon;
  final String email;
  final id;

  const StudentEditPage(
      {super.key,
      required this.id,
      required this.npm,
      required this.nama,
      required this.email,
      required this.telepon});

  // final Kompetensi kompetensi;

  @override
  _StudentEditPageState createState() => _StudentEditPageState();
}

class _StudentEditPageState extends State<StudentEditPage> {
  // A key for managing the form
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _npmController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _userID = TextEditingController();

  late Future<List<Mahasiswa>> _mahasiswaFuture;
  List<dynamic>? _studentDatas; //edited line

  var token = '';

  @override
  void initState() {
    super.initState();
    _userID.text = widget.id;
    _npmController.text = widget.npm;
    _nameController.text = widget.nama;
    _emailController.text = widget.email;
    _teleponController.text = widget.telepon;
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
                  controller: _nameController,
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
                  controller: _npmController,
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
                  controller: _emailController,
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
                  controller: _teleponController,
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

  Future<void> _submitForm() async {
    // Check if the form is valid
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save the form data

      Mahasiswa mahasiswa = Mahasiswa(
          int.parse(_userID.text),
          _npmController.text,
          _nameController.text,
          _teleponController.text,
          _emailController.text);

      if (await mahasiswa.update()) {
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
