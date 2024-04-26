class Kompetensi {
  int? id;
  String? uuid;
  String? namaKompetensi;
  double? persentase;

  Kompetensi({this.id, this.uuid, this.namaKompetensi, this.persentase});

  Kompetensi.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    id = json['id'];
    namaKompetensi = json['nama_kompetensi'];
    persentase = json['persentase'];
  }
}
