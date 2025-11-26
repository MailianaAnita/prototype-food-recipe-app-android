import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HalamanTambahPostingan extends StatefulWidget {
  const HalamanTambahPostingan({super.key});

  @override
  State<HalamanTambahPostingan> createState() => _HalamanTambahPostinganState();
}

class _HalamanTambahPostinganState extends State<HalamanTambahPostingan> {
  final TextEditingController namaResepController = TextEditingController();
  final TextEditingController langkahController = TextEditingController();
  final TextEditingController alatBahanController = TextEditingController();

  File? fotoFile;
  File? videoFile;

  Uint8List? fotoBytes;
  Uint8List? videoBytes;

  VideoPlayerController? videoController;
  ChewieController? chewieController;

  bool isUploading = false;
  bool isButtonPressed = false;

  final supabase = Supabase.instance.client;

  void resetForm() {
    namaResepController.clear();
    alatBahanController.clear();
    langkahController.clear();

    fotoFile = null;
    fotoBytes = null;

    videoFile = null;
    videoBytes = null;

    videoController?.dispose();
    chewieController?.dispose();
    videoController = null;
    chewieController = null;

    setState(() {});
  }

  Future pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null) {
      if (kIsWeb) {
        fotoBytes = result.files.single.bytes;
        fotoFile = null;
      } else {
        fotoFile = File(result.files.single.path!);
      }
      setState(() {});
    }
  }

  Future pickVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
      withData: true,
    );

    if (result != null) {
      if (kIsWeb) {
        videoBytes = result.files.single.bytes;
        videoFile = null;

        videoController = VideoPlayerController.networkUrl(
          Uri.dataFromBytes(videoBytes!, mimeType: 'video/mp4'),
        );
      } else {
        videoFile = File(result.files.single.path!);
        videoController = VideoPlayerController.file(videoFile!);
      }

      await videoController!.initialize();

      chewieController = ChewieController(
        videoPlayerController: videoController!,
        autoPlay: false,
        looping: false,
      );

      setState(() {});
    }
  }

  Future uploadPostingan() async {
    if (namaResepController.text.isEmpty ||
        langkahController.text.isEmpty ||
        alatBahanController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Isi dulu ya semuanya :)")));
      return;
    }

    setState(() => isUploading = true);

    try {
      String? fotoUrl;
      String? videoUrl;

      // Upload FOTO
      if (kIsWeb && fotoBytes != null) {
        final fileName = "foto_${DateTime.now().millisecondsSinceEpoch}.jpg";
        await supabase.storage
            .from('ricipe_makan')
            .uploadBinary(fileName, fotoBytes!);
        fotoUrl = supabase.storage.from('ricipe_makan').getPublicUrl(fileName);
      } else if (!kIsWeb && fotoFile != null) {
        final fileName = "foto_${DateTime.now().millisecondsSinceEpoch}.jpg";
        await supabase.storage.from('ricipe_makan').upload(fileName, fotoFile!);
        fotoUrl = supabase.storage.from('ricipe_makan').getPublicUrl(fileName);
      }

      // Upload VIDEO
      if (kIsWeb && videoBytes != null) {
        final fileName = "video_${DateTime.now().millisecondsSinceEpoch}.mp4";
        await supabase.storage
            .from('ricipe_makan')
            .uploadBinary(fileName, videoBytes!);
        videoUrl = supabase.storage.from('ricipe_makan').getPublicUrl(fileName);
      } else if (!kIsWeb && videoFile != null) {
        final fileName = "video_${DateTime.now().millisecondsSinceEpoch}.mp4";
        await supabase.storage
            .from('ricipe_makan')
            .upload(fileName, videoFile!);
        videoUrl = supabase.storage.from('ricipe_makan').getPublicUrl(fileName);
      }

      final bahanList = alatBahanController.text.trim().split("\n").toList();
      final langkahList = langkahController.text.trim().split("\n").toList();
      // Ambil UID Firebase milik user yang sedang login
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await supabase.from('resep').insert({
        'nama_resep': namaResepController.text.trim(),
        'bahan': bahanList,
        'langkah': langkahList,
        'foto_url': fotoUrl,
        'video_url': videoUrl,
        'tanggal': DateTime.now().toIso8601String(),
        'user_id': uid,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Resep berhasil di-upload!"),
          backgroundColor: Colors.orange,
        ),
      );

      resetForm();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) {
        setState(() => isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Postingan")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: namaResepController,
              decoration: const InputDecoration(
                labelText: "Nama Resep",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: alatBahanController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Alat & Bahan",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: langkahController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: "Langkah-langkah",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),
            const Text("Foto Makanan", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),

            fotoFile == null && fotoBytes == null
                ? ElevatedButton(
                  onPressed: pickImage,
                  child: const Text("Pilih Foto"),
                )
                : Stack(
                  children: [
                    Container(
                      height: 180,
                      width: double.infinity,
                      child:
                          fotoBytes != null
                              ? Image.memory(fotoBytes!, fit: BoxFit.cover)
                              : Image.file(fotoFile!, fit: BoxFit.cover),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            fotoFile = null;
                            fotoBytes = null;
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

            const SizedBox(height: 25),
            const Text("Video Makanan", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),

            videoController == null
                ? ElevatedButton(
                  onPressed: pickVideo,
                  child: const Text("Pilih Video"),
                )
                : Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Chewie(controller: chewieController!),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            videoFile = null;
                            videoBytes = null;

                            videoController?.dispose();
                            chewieController?.dispose();
                            videoController = null;
                            chewieController = null;
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

            const SizedBox(height: 20),

            GestureDetector(
              onTapDown: (_) {
                setState(() {
                  isButtonPressed = true;
                });
              },
              onTapUp: (_) async {
                setState(() {
                  isButtonPressed = false;
                });
                await uploadPostingan();
              },
              onTapCancel: () {
                setState(() {
                  isButtonPressed = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color:
                      isButtonPressed
                          ? Colors.orange.shade300
                          : const Color.fromARGB(255, 222, 192, 128),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow:
                      isButtonPressed
                          ? []
                          : [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                ),
                child: Center(
                  child: Text(
                    isUploading ? "Mengunggah..." : "Simpan Postingan",
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
