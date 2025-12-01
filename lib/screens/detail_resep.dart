//DESIGN BAGIAN DI RESEP POPULER (DI HOME)

import 'package:flutter/material.dart';
import 'package:recipe_makan/models/recipe_models.dart';
import 'video_player_page.dart';

class DetailResep extends StatefulWidget {
  final Resep resep;

  const DetailResep({super.key, required this.resep});

  @override
  State<DetailResep> createState() => _DetailResepState();
}

class _DetailResepState extends State<DetailResep> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PAGEVIEW FOTO + VIDEO
            SizedBox(
              height: 250,
              width: double.infinity,
              child: PageView(
                onPageChanged: (index) {
                  setState(() => currentPage = index);
                },
                children: [
                  // Foto pertama
                  Image.asset(widget.resep.gambar, fit: BoxFit.cover),

                  // Slide kedua (Video)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => VideoPlayerPage(
                                videoPath: widget.resep.video,
                              ),
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.black,
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Indikator Titik
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: currentPage == 0 ? 10 : 8,
                  height: currentPage == 0 ? 10 : 8,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: currentPage == 0 ? Colors.orange : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: currentPage == 1 ? 10 : 8,
                  height: currentPage == 1 ? 10 : 8,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: currentPage == 1 ? Colors.orange : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),

            // NAMA RESEP
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.resep.nama,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // BAGIAN BAHAN
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Bahan:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    widget.resep.bahan
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              "• $item",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),

            const SizedBox(height: 20),

            // BAGIAN LANGKAH
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Cara Membuat:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    widget.resep.langkah.asMap().entries.map((entry) {
                      final index = entry.key + 1;
                      final step = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          "$index. $step",
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
