import 'package:flutter/material.dart';
import 'package:recipe_makan/models/recipe_models.dart';

class KartuResep extends StatefulWidget {
  final Resep resep;
  final VoidCallback onTap;

  const KartuResep({super.key, required this.resep, required this.onTap});

  @override
  State<KartuResep> createState() => _KartuResepState();
}

class _KartuResepState extends State<KartuResep> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.95);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.orange.shade50, // background orange soft
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.orange.shade300, width: 2),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  widget.resep.gambar,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.resep.nama,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
