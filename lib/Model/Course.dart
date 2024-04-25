class Course {
  int? id;
  String? uuid;
  String? namaMataKuliah;

  Course({this.id, this.uuid, this.namaMataKuliah});

  Course.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    id = json['id'];
    namaMataKuliah = json['nama_mata_kuliah'];
  }
}
