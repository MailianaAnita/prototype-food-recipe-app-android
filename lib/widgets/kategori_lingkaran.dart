import 'package:flutter/material.dart';
import 'package:recipe_makan/screens/kategori_page.dart';
import 'package:recipe_makan/screens/kategori_page.dart';

class DaftarKategoriLingkaran extends StatelessWidget {
  const DaftarKategoriLingkaran({super.key});

  @override
  Widget build(BuildContext context) {
    final kategori = [
      {
        "nama": "Minuman",
        "gambar":
            "https://tse3.mm.bing.net/th/id/OIP.oV6D-2PGFWE3_j2KNB75kAHaE8?rs=1&pid=ImgDetMain&o=7&rm=3",
      },
      {
        "nama": "Jajanan",
        "gambar":
            "https://thumbs.dreamstime.com/z/jajanan-pasar-various-colorful-traditional-indonesian-snacks-top-view-283226291.jpg",
      },
      {
        "nama": "Aneka Nasi",
        "gambar":
            "https://tse1.mm.bing.net/th/id/OIP.wcQIQytb7b55P--hLOQHegHaHr?rs=1&pid=ImgDetMain&o=7&rm=3",
      },
      {
        "nama": "Bakery",
        "gambar":
            "https://tse1.mm.bing.net/th/id/OIP.KuBPVsiI6QFfXPoG4lk7tgHaE7?rs=1&pid=ImgDetMain&o=7&rm=3",
      },
      {
        "nama": "Ayam & Bebek",
        "gambar":
            "https://img.okezone.com/content/2021/03/15/298/2377850/bebek-dan-ayam-betutu-kuliner-khas-bali-sejak-zaman-majapahit-PXp6yB3HPM.jpg",
      },
      {
        "nama": "Bakso & Soto",
        "gambar":
            "https://tse1.mm.bing.net/th/id/OIP.QYSnm1CUvHCyXM8AlooLlAHaJQ?rs=1&pid=ImgDetMain&o=7&rm=3",
      },
      {
        "nama": "Cake",
        "gambar":
            "https://www.supergoldenbakes.com/wordpress/wp-content/uploads/2023/05/Mary_Berry_Salted_Caramel_Cake-1.jpg",
      },
      {
        "nama": "Korea",
        "gambar":
            "https://tse3.mm.bing.net/th/id/OIP.IvXeQEVtUPIK9en4Eb1TyAHaFj?rs=1&pid=ImgDetMain&o=7&rm=3",
      },
      {
        "nama": "Bakmie",
        "gambar":
            "https://images.bisnis.com/posts/2023/08/22/1687037/bakmi_gm_1692680061.jpg",
      },
      {
        'nama': 'Chinese',
        'gambar':
            'https://tse3.mm.bing.net/th/id/OIP.pN4vc-z3BNlfRvoRsMlQVgHaFa?pid=Api&P=0&h=180',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),

        // List kategori horizontal
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: kategori.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final item = kategori[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(
                      item["nama"]! != null ? item["gambar"]! : '',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item["nama"]!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
