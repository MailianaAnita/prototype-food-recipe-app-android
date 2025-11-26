import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:recipe_makan/data/resep_data.dart';
import 'package:recipe_makan/models/recipe_models.dart';
import '../widgets/banner_slider.dart';
import '../widgets/kategori_lingkaran.dart';
import '../widgets/kartu_produk.dart';
import '../screens/kategori_page.dart';
import 'package:recipe_makan/screens/search_page.dart';

class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    final kategori = [
      {
        'judul': 'Minuman',
        'gambar':
            'https://tse3.mm.bing.net/th/id/OIP.oV6D-2PGFWE3_j2KNB75kAHaE8?rs=1&pid=ImgDetMain&o=7&rm=3',
      },
      {
        'judul': 'Jajanan',
        'gambar':
            'https://thumbs.dreamstime.com/z/jajanan-pasar-various-colorful-traditional-indonesian-snacks-top-view-283226291.jpg',
      },
      {
        'judul': 'Aneka Nasi',
        'gambar':
            'https://tse1.mm.bing.net/th/id/OIP.wcQIQytb7b55P--hLOQHegHaHr?rs=1&pid=ImgDetMain&o=7&rm=3',
      },
      {
        'judul': 'Bakery',
        'gambar':
            'https://tse1.mm.bing.net/th/id/OIP.KuBPVsiI6QFfXPoG4lk7tgHaE7?rs=1&pid=ImgDetMain&o=7&rm=3',
      },
      {
        'judul': 'Ayam & Bebek',
        'gambar':
            'https://img.okezone.com/content/2021/03/15/298/2377850/bebek-dan-ayam-betutu-kuliner-khas-bali-sejak-zaman-majapahit-PXp6yB3HPM.jpg',
      },
      {
        'judul': 'Bakso & Soto',
        'gambar':
            'https://tse1.mm.bing.net/th/id/OIP.QYSnm1CUvHCyXM8AlooLlAHaJQ?rs=1&pid=ImgDetMain&o=7&rm=3',
      },
      {
        'judul': 'Cake',
        'gambar':
            'https://www.supergoldenbakes.com/wordpress/wp-content/uploads/2023/05/Mary_Berry_Salted_Caramel_Cake-1.jpg',
      },
      {
        'judul': 'Korea',
        'gambar':
            'https://tse3.mm.bing.net/th/id/OIP.IvXeQEVtUPIK9en4Eb1TyAHaFj?rs=1&pid=ImgDetMain&o=7&rm=3',
      },
      {
        'judul': 'Bakmie',
        'gambar':
            'https://images.bisnis.com/posts/2023/08/22/1687037/bakmi_gm_1692680061.jpg',
      },
      {
        'judul': 'Chinese',
        'gambar':
            'https://tse3.mm.bing.net/th/id/OIP.pN4vc-z3BNlfRvoRsMlQVgHaFa?pid=Api&P=0&h=180',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 700),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, (1 - value) * 20),
                    child: Opacity(
                      opacity: value,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // WELCOME TEXT (KIRI)
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const WelcomeAnimatedText(),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Mau masak apa hari ini?",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.orange.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            // MINI BANNER (KANAN)
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade200,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.local_dining,
                                      size: 28,
                                      color: Colors.orange.shade900,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Yuk coba resep\nbaru hari ini",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.orange.shade900,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Search Bar — PINNED
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 2,
              toolbarHeight: 70,
              automaticallyImplyLeading: false,
              title: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(35),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  readOnly: true,
                  onTap: () {
                    showSearchSheet(context);
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Cari resep atau bahan...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            // Konten scroll biasa
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 16),

                  // Banner geser
                  const BannerSlider(),
                  const SizedBox(height: 16),

                  // Bagian kategori
                  _buatJudulBagian(context, "Kategori", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KategoriPage(kategori: kategori),
                      ),
                    );
                  }),

                  const SizedBox(height: 8),
                  const DaftarKategoriLingkaran(),
                  const SizedBox(height: 16),

                  // Bagian produk
                  _buatJudul("Resep Populer"),
                  const SizedBox(height: 8),
                  const GridProduk(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSearchSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white.withOpacity(0.9),
            padding: const EdgeInsets.only(
              top: 60,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),

                // SEARCH BAR DI ATAS
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Cari resep...",
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onSubmitted: (keyword) {
                    if (keyword.trim().isEmpty) return;

                    Navigator.pop(context); // tutup sheet
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => SearchPage(
                              semuaResep: semuaResep,
                              keyword: keyword,
                            ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
                const Text(
                  "Cari resep terbaru...",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buatJudulBagian(
    BuildContext context,
    String judul,
    VoidCallback onTap,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          judul,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ],
    );
  }
}

Widget _buatJudul(String judul) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        judul,
        style: const TextStyle(
          fontSize: 20,
          fontFamily: "Poppins",
          fontWeight: FontWeight.bold,
        ),
      ),
      const Icon(Icons.arrow_forward_ios, size: 16),
    ],
  );
}

class WelcomeAnimatedText extends StatefulWidget {
  const WelcomeAnimatedText({super.key});

  @override
  _WelcomeAnimatedTextState createState() => _WelcomeAnimatedTextState();
}

class _WelcomeAnimatedTextState extends State<WelcomeAnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: Text(
          "Welcome sobat D'Mita!!",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.orange.shade800,
          ),
        ),
      ),
    );
  }
}
