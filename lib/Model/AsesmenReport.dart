class AsesmenReport {
  int? id;
  String? namaMahasiswa;
  double? skorKognitif;
  double? skorPsikomotorik;

  AsesmenReport({this.id, this.skorKognitif, this.skorPsikomotorik});

  AsesmenReport.fromJson(Map<String, dynamic> json) {
    namaMahasiswa = json['uuid'];
    id = json['id'];
    skorKognitif = json['nama_asesmen'];
    skorPsikomotorik = json['nama_asesmen'];
  }
}
