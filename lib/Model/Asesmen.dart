class Asesmen {
  int? id;
  String? uuid;
  String? namaAsesmen;

  Asesmen({this.id, this.uuid, this.namaAsesmen});

  Asesmen.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    id = json['id'];
    namaAsesmen = json['nama_asesmen'];
  }
}
