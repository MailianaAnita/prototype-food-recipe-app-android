//BUAT GRID BACKGROUND DI RESEP POPULER

import 'package:flutter/material.dart';
import 'package:recipe_makan/models/recipe_models.dart';
import 'package:recipe_makan/widgets/kartu_resep.dart';
import '../screens/detail_resep.dart';

class GridProduk extends StatelessWidget {
  final List<Resep> semuaResep;

  const GridProduk({super.key, required this.semuaResep});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: semuaResep.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          final resep = semuaResep[index];
          return KartuResep(
            resep: resep,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetailResep(resep: resep)),
              );
            },
          );
        },
      ),
    );
  }
}
