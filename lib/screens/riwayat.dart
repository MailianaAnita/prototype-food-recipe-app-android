import 'package:flutter/material.dart';

class RiwayatScreen extends StatelessWidget {
  const RiwayatScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Riwayat")),
      body: Center(
        child: Text(
          "Belum ada riwayat apapun disini",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
