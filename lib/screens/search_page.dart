import 'package:flutter/material.dart';
import 'package:recipe_makan/models/recipe_models.dart';
import 'package:recipe_makan/screens/halamandetailresep.dart';

class SearchPage extends StatelessWidget {
  final List<Resep> semuaResep;
  final String keyword;

  const SearchPage({
    super.key,
    required this.semuaResep,
    required this.keyword,
  });

  @override
  Widget build(BuildContext context) {
    final hasil =
        semuaResep.where((resep) {
          return resep.nama.toLowerCase().contains(keyword.toLowerCase());
        }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Hasil Pencarian')),
      body:
          hasil.isEmpty
              ? Center(
                child: Text(
                  'Kata kunci "$keyword" tidak ditemukan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
              : ListView.builder(
                itemCount: hasil.length,
                itemBuilder: (context, index) {
                  final resep = hasil[index];
                  return ListTile(
                    leading: Image.asset(
                      resep.gambar,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(resep.nama),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => HalamanDetailResep(
                                resep: {
                                  "nama_resep": resep.nama,
                                  "foto_url": resep.gambar,
                                  "video_url": resep.video,
                                  "bahan": resep.bahan,
                                  "langkah": resep.langkah,
                                },
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
