class Asesmen {
  int? id;
  String? uuid;
  String? namaAsesmen;
  String? sumberNilai1;
  String? sumberNilai2;

  Asesmen({this.id, this.uuid, this.namaAsesmen});

  Asesmen.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    id = json['id'];
    namaAsesmen = json['nama_asesmen'];
    sumberNilai1 = json['sumber_nilai1'];
    sumberNilai2 = json['sumber_nilai2'];
  }
}
