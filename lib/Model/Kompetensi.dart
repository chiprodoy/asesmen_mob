class Kompetensi {
  int? id;
  String? uuid;
  String? namaKompetensi;
  double? persentase;
  int? asesmenId;

  Kompetensi(
      {this.id,
      this.uuid,
      this.namaKompetensi,
      this.persentase,
      this.asesmenId});

  Kompetensi.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    id = json['id'];
    namaKompetensi = json['nama_kompetensi'];
    persentase = double.parse(json['persentase']);
    asesmenId = json['asesmen_id'];
  }
}
