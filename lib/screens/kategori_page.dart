import 'package:flutter/material.dart';
import 'package:recipe_makan/screens/halaman_kategori_detail.dart';

class KategoriPage extends StatelessWidget {
  final List<Map<String, String>> kategori;
  const KategoriPage({super.key, required this.kategori});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Semua Kategori'),
        backgroundColor: const Color.fromARGB(255, 212, 148, 80),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: kategori.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final data = kategori[index];
            return Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),

                // Efek tekan kedalam
                overlayColor: WidgetStateProperty.all(
                  Colors.orange.withOpacity(0.15),
                ),
                highlightColor: Colors.orange.withOpacity(0.25),
                splashColor: Colors.orange.withOpacity(0.2),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              HalamanKategoriDetail(judul: data['judul']!),
                    ),
                  );
                },

                child: Hero(
                  tag: data['judul']!,
                  child: Ink(//  Ink agar efek overlay terlihat penuh
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 6,
                          offset: const Offset(2, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: Image.network(
                                data['gambar']!,
                                key: ValueKey(data['gambar']),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder:
                                    (context, error, stackTrace) => const Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data['judul']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
