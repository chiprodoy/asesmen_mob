import 'package:asesmen_ners/LandingPage.dart';
import 'package:asesmen_ners/MahasiswaCoursePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'LoginPage.dart';
import 'MahasiswaChangePasswordPage.dart';
import 'MahasiswaLandingPage.dart';
import 'MahasiswaProfilPage.dart';
import 'Services/Api.dart';
import 'package:http/http.dart' as http;

class MahasiswaSideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
      DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Text(
          'Menu',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      ListTile(
        leading: Icon(Icons.home),
        title: Text('Home'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MahasiswaLandingPage(),
            ),
          );
          // Navigate to Home
        },
      ),
      ListTile(
        leading: Icon(Icons.rate_review),
        title: Text('Hasil Penilaian'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MahasiswaCoursePage(),
            ),
          );
          // Navigate to Home
        },
      ),
      ListTile(
        leading: Icon(Icons.manage_accounts),
        title: Text('Profil'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MahasiswaProfilPage(),
            ),
          );
          // Navigate to Profile
        },
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text('Ganti Password'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MahasiswaChangePasswordPage(),
            ),
          );
          // Navigate to Settings
        },
      ),
      ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Logout'),
        onTap: () {
          _signOut(context);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false,
          );
          // Handle logout
        },
      )
    ]));
  }

  Future<bool> _signOut(BuildContext context) async {
    // Header untuk permintaan HTTP
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      // Mengirim permintaan POST ke API
      http.Response response = await http.get(
        Uri.parse('${Api.host}/logout'),
        headers: headers,
      );

      // Memeriksa kode status respons
      if (response.statusCode == 200) {
        // Autentikasi berhasil, lakukan tindakan selanjutnya

        const storage = FlutterSecureStorage();
        await storage.deleteAll();
        return true;
      } else {
        // Autentikasi gagal, tampilkan pesan kesalahan
        return false;
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert('Logout gagal', 'Terjadi kesalahan: $error');
        },
      );
      // Menangani kesalahan yang mungkin terjadi
      return false;
    }
  }

  AlertDialog alert(String title, String message) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {},
    );
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [okButton],
    );
    return alert;
  }
}
