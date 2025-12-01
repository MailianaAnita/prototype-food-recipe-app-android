import 'package:flutter/material.dart';

class BannerSlider extends StatelessWidget {
  const BannerSlider({super.key});

  @override
  Widget build(BuildContext context) {
    // 3 Gambar berbeda
    final List<String> images = [
      "https://tse2.mm.bing.net/th/id/OIP.CJxbYOsbejj190Dw849MKQHaE7?pid=Api&P=0&h=180",
      "https://tse3.mm.bing.net/th/id/OIP.oV6D-2PGFWE3_j2KNB75kAHaE8?pid=Api&P=0&h=180",
      "https://tse2.mm.bing.net/th/id/OIP.mM4OpCF23_1OQgRbAuO10wHaHa?pid=Api&P=0&h=180",
    ];

    final List<String> titles = ["Makanan", "Minuman", "Cake"];

    return SizedBox(
      height: 140,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              image: DecorationImage(
                image: NetworkImage(images[index]),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(16),
            child: Text(
              titles[index],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 6, color: Colors.black54)],
              ),
            ),
          );
        },
      ),
    );
  }
}
