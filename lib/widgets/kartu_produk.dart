import 'package:flutter/material.dart';
import 'package:recipe_makan/data/resep_data.dart';
import 'package:recipe_makan/widgets/kartu_resep.dart';
import 'package:recipe_makan/screens/detail_resep.dart';

class GridProduk extends StatelessWidget {
  const GridProduk({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: semuaResep.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
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
    );
  }
}
