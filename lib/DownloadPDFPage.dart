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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download complete, file saved at $filePath')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission denied')),
      );
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
      body: const PDF(swipeHorizontal: true).fromUrl(
        widget.url,
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
