class Resep {
  final String nama;
  final String gambar;       // URL gambar
  final String video;        // URL video (opsional)
  final List<String> bahan;
  final List<String> langkah;

  Resep({
    required this.nama,
    required this.gambar,
    required this.video,
    required this.bahan,
    required this.langkah,
  });
}
