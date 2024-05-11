class SubKompetensi {
  int? id;
  String? uuid;
  String? namaSubKompetensi;
  String? skorPenilaian;
  SubKompetensi(
      {this.id, this.uuid, this.namaSubKompetensi, this.skorPenilaian});

  SubKompetensi.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    id = json['id'];
    namaSubKompetensi = json['nama_sub_kompetensi'];
    skorPenilaian = json['skor_penilaian'];
  }
}
