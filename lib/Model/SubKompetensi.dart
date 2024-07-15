import 'package:asesmen_ners/Model/Asesmen.dart';
import 'package:asesmen_ners/Model/Kompetensi.dart';

class SubKompetensi {
  int? id;
  String? uuid;
  String? namaSubKompetensi;
  String? skorPenilaian;
  //Kompetensi? kompetensi;
  SubKompetensi({
    this.id,
    this.uuid,
    this.namaSubKompetensi,
    this.skorPenilaian,
    //this.kompetensi
  });

  SubKompetensi.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    id = json['id'];
    namaSubKompetensi = json['nama_sub_kompetensi'];
    skorPenilaian = json['skor_penilaian'];
    //kompetensi = Kompetensi.fromJson(json['kompetensi']);
  }
}
