import 'package:asesmen_ners/Model/SubKompetensi.dart';

class Kompetensi {
  int? id;
  String? uuid;
  String? namaKompetensi;
  double? persentase;
  int? asesmenId;
  List<SubKompetensi>? subKompetensi;

  Kompetensi(
      {this.id,
      this.uuid,
      this.namaKompetensi,
      this.persentase,
      this.asesmenId,
      this.subKompetensi});

  Kompetensi.fromJson(Map<String, dynamic> json) {
    var list = json['sub_kompetensi'] as List;
    List<SubKompetensi> subKompetensiList =
        list.map((i) => SubKompetensi.fromJson(i)).toList();

    uuid = json['uuid'];
    id = json['id'];
    namaKompetensi = json['nama_kompetensi'];
    persentase = double.parse(json['persentase']);
    subKompetensi = subKompetensiList;
  }
}
