import 'package:asesmen_ners/SideMenu.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class DownloadPDFPage extends StatefulWidget {
  final String url;

  //const DownloadPDFPage({super.key, required this.url});
  const DownloadPDFPage({super.key, required this.url});

  @override
  PDFViewerFromUrl createState() => PDFViewerFromUrl();
}

class PDFViewerFromUrl extends State<DownloadPDFPage> {
  //const PDFViewerFromUrl({Key? key, required this.url}) : super(key: key);

  // final String url;
  bool _isLoading = false;
  double _progress = 0.0;

  Future<void> _downloadFile(String url) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      setState(() {
        _isLoading = true;
      });

      try {
        final dio = Dio();
        final dir = await getExternalStorageDirectory();
        final filePath = '${dir?.path}/report.pdf';
        await dio.download(
          url,
          filePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() {
                _progress = received / total;
              });
            }
          },
        );

        _dialogBuilder(
            context, 'Download', 'Download complete, file saved at $filePath');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Downlod Failed : Nilai Tidak ditemukan, silahkan input nilai terlebih dahulu')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      _dialogBuilder(context, 'Download', 'Permission Denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Laporan Asesmen'),
          actions: [
            IconButton(
              icon: const Icon(Icons.download),
              tooltip: 'Download File',
              onPressed: () {
                // handle the press
                _downloadFile(widget.url);
              },
            ),
          ],
        ),
        endDrawer: SideMenu(),
        body: const PDF(swipeHorizontal: true).fromUrl(
          widget.url,
          placeholder: (double progress) => Center(child: Text('$progress %')),
          errorWidget: (dynamic error) => Center(
              child: Text(
                  'Nilai Tidak ditemukan, silahkan input nilai terlebih dahulu')),
        ));
  }

  Future<void> _dialogBuilder(BuildContext context, titleMsg, textMsg,
      {String type = 'success'}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titleMsg),
          content: Text(textMsg),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  showAlertDialog(BuildContext context, String title, String msg) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
