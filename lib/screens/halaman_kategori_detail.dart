import 'package:flutter/material.dart';

class HalamanKategoriDetail extends StatelessWidget {
  final String judul;

  const HalamanKategoriDetail({super.key, required this.judul});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
        backgroundColor: const Color.fromARGB(255, 212, 148, 80),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Halaman kategori masih kosong 😄",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
