class Dosen {
  int? id;
  String? nidn;
  String? nama;

  Dosen({this.id, this.nidn, this.nama});

  Dosen.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nidn = json['nidn'];
    nama = json['nama'];
  }
}
