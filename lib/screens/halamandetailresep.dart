import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class HalamanDetailResep extends StatefulWidget {
  final Map<String, dynamic> resep;

  const HalamanDetailResep({super.key, required this.resep});

  @override
  State<HalamanDetailResep> createState() => _HalamanDetailResepState();
}

class _HalamanDetailResepState extends State<HalamanDetailResep> {
  VideoPlayerController? videoController;
  ChewieController? chewieController;
  final PageController _pageController = PageController();


  @override
  void initState() {
    super.initState();

    final videoUrl = widget.resep["video_url"];

    // VIDEO: ASSET / NETWORK

    if (videoUrl != null && videoUrl.isNotEmpty) {
      if (videoUrl.startsWith("assets/")) {
        // Video dari asset
        videoController = VideoPlayerController.asset(videoUrl);
      } else {
        // Video dari internet
        videoController = VideoPlayerController.network(videoUrl);
      }

      videoController!.initialize().then((_) {
        chewieController = ChewieController(
          videoPlayerController: videoController!,
          autoPlay: false,
          looping: false,
        );
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    videoController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  // FOTO: ASSET / NETWORK

  Widget _buildImage(String fotoUrl) {
    if (fotoUrl.startsWith("assets/")) {
      return Image.asset(fotoUrl, width: double.infinity, fit: BoxFit.cover);
    } else {
      return Image.network(fotoUrl, width: double.infinity, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bahan = List<String>.from(widget.resep["bahan"]);
    final langkah = List<String>.from(widget.resep["langkah"]);

    return Scaffold(
      appBar: AppBar(title: Text(widget.resep["nama_resep"])),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FOTO & VIDEO PAGEVIEW
            SizedBox(
  height: 300,
  child: PageView(
    controller: _pageController,
    children: [
      _buildImage(widget.resep["foto_url"]),
      if (chewieController != null)
        Chewie(controller: chewieController!),
    ],
  ),
),
const SizedBox(height: 10),
Center(
  child: SmoothPageIndicator(
    controller: _pageController,
    count: chewieController != null ? 2 : 1,
    effect: WormEffect(
      dotHeight: 10,
      dotWidth: 10,
      activeDotColor: Colors.orange,
      dotColor: Colors.grey,
    ),
  ),
),


            // Nama
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.resep["nama_resep"],
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Bahan
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Bahan:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ...bahan.map(
              (b) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Text("• $b"),
              ),
            ),

            const SizedBox(height: 20),

            //  Langkah
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Cara Membuat:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ...langkah.asMap().entries.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: Text("${e.key + 1}. ${e.value}"),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
