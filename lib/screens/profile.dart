import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_makan/screens/setting.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import 'package:recipe_makan/screens/halamandetailresep.dart';
import 'package:image_picker/image_picker.dart';

class HalamanProfil extends StatefulWidget {
  const HalamanProfil({super.key});

  @override
  State<HalamanProfil> createState() => _HalamanProfilState();
}

class _HalamanProfilState extends State<HalamanProfil> {
  late User _user;
  final supabase = supa.Supabase.instance.client;
  File? _fotoProfil;
  String? fotoProfilUrl;

  Future<void> loadFotoProfil() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final data =
        await supabase
            .from('user_profile')
            .select('foto_url')
            .eq('user_id', uid)
            .maybeSingle();

    if (mounted) {
      setState(() {
        fotoProfilUrl = data?['foto_url'];
        _fotoProfil = null; // File lokal kosong, pakai NetworkImage
      });
    }
  }

  Future<void> pilihFotoProfil() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final file = File(image.path);
    setState(() => _fotoProfil = file);

    try {
      final fileName = 'profil_${_user.uid}.jpg';

      // Upload dengan upsert: true agar bisa overwrite
      await supabase.storage
          .from('profile-pictures')
          .uploadBinary(
            fileName,
            await file.readAsBytes(),
            fileOptions: supa.FileOptions(upsert: true),
          );

      // Ambil URL baru
      final url = supabase.storage
          .from('profile-pictures')
          .getPublicUrl(fileName);

      // Simpan ke database
      await supabase.from('user_profile').upsert({
        'user_id': _user.uid,
        'foto_url': url,
        'updated_at': DateTime.now().toIso8601String(),
      });

      setState(() {
        fotoProfilUrl = url;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto profil berhasil diganti")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal upload foto: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> hapusFotoProfil() async {
    try {
      final fileName = 'profil_${_user.uid}.jpg';

      // Coba hapus file dari storage
      await supabase.storage.from('profile-pictures').remove([fileName]);

      // Set foto_url ke null di database
      await supabase
          .from('user_profile')
          .update({'foto_url': null})
          .eq('user_id', _user.uid);

      setState(() {
        _fotoProfil = null;
        fotoProfilUrl = null;
        ;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto profil berhasil dihapus")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menghapus foto: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _tampilkanMenuFoto() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Foto Profil"),
          content: const Text("Apa yang ingin kamu lakukan?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                hapusFotoProfil();
              },
              child: const Text(
                "Hapus Foto",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    loadFotoProfil();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        setState(() => _user = user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final username = _user.displayName ?? "User";
    final email = _user.email ?? "-";

    return Scaffold(
      body: Column(
        children: [
          // HEADER
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade300, Colors.orange.shade200],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Jika foto tidak ada → tampilkan pesan
                        if (_fotoProfil == null &&
                            (fotoProfilUrl == null || fotoProfilUrl!.isEmpty)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Foto profil kosong"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          // Jika ada foto → tampilkan dialog hapus
                          _tampilkanMenuFoto();
                        }
                      },
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            _fotoProfil != null
                                ? FileImage(_fotoProfil!)
                                : (fotoProfilUrl != null
                                    ? NetworkImage(fotoProfilUrl!)
                                    : null),
                        child:
                            (_fotoProfil == null && fotoProfilUrl == null)
                                ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey,
                                )
                                : null,
                      ),
                    ),

                    // Tombol Upload
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: pilihFotoProfil,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.add,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 16),

                //  USER INFO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        email,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(color: Colors.white.withOpacity(0.9)),
                      ),

                      const SizedBox(height: 12),

                      // TOTAL RESEP
                      FutureBuilder(
                        future: supabase
                            .from("resep")
                            .select("*")
                            .eq(
                              "user_id",
                              FirebaseAuth.instance.currentUser!.uid,
                            ),
                        builder: (context, snapshot) {
                          int totalResep = 0;

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                              color: Colors.white,
                            );
                          }

                          if (snapshot.hasData) {
                            final list = snapshot.data as List;
                            totalResep = list.length;
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "$totalResep",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    "Resep",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const Column(
                                children: [
                                  Text(
                                    "0",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "Pengikut",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const Column(
                                children: [
                                  Text(
                                    "0",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "Mengikuti",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 8),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "0 Points",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).push(_buatRutePengaturan());
                  },
                ),
              ],
            ),
          ),

          //  TAB VIEW
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Colors.orange,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.orange,
                    tabs: [
                      Tab(text: "Resep Saya"),
                      Tab(text: "Resep Disimpan"),
                      Tab(text: "Resep Suka"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        const _ResepSaya(),
                        const _EmptyState(),
                        const _EmptyState(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Route _buatRutePengaturan() {
    return PageRouteBuilder(
      pageBuilder:
          (context, animation, secondaryAnimation) => const HalamanPengaturan(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}

//  TAB: RESEP SAYA
class _ResepSaya extends StatefulWidget {
  const _ResepSaya();

  @override
  State<_ResepSaya> createState() => _ResepSayaState();
}

class _ResepSayaState extends State<_ResepSaya> {
  final supabase = supa.Supabase.instance.client;

  List<dynamic> resepList = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final data = await supabase
          .from("resep")
          .select("*")
          .eq("user_id", uid) // FILTER DATA MILIK USER
          .order("tanggal", ascending: false);

      setState(() {
        resepList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isError) {
      return const Center(child: Text("Terjadi kesalahan"));
    }

    if (resepList.isEmpty) {
      return const _EmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: resepList.length,
      itemBuilder: (context, index) {
        final resep = resepList[index];
        final id = resep["id"];

        return Dismissible(
          key: Key(id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete, color: Colors.white, size: 30),
          ),

          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Hapus Resep"),
                  content: const Text(
                    "Apakah kamu yakin ingin menghapus resep ini?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Batal"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        "Hapus",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );
          },

          onDismissed: (direction) async {
            try {
              await supabase.from("resep").delete().eq("id", id);

              setState(() {
                resepList.removeAt(index); // hapus dari UI
              });

              // Update header profil
              final parentState =
                  context.findAncestorStateOfType<_HalamanProfilState>();
              parentState?.setState(() {});

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Resep berhasil dihapus")),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Gagal menghapus resep: $e"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },

          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HalamanDetailResep(resep: resep),
                  ),
                );
              },
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  resep["foto_url"],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  headers: const {"Content-Type": "image/jpeg"},

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image_not_supported),
                    );
                  },

                  // Loading indicator di Web / Mobile
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 60,
                      height: 60,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                ),
              ),
              title: Text(
                resep["nama_resep"] ?? "-",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Diposting: ${resep["tanggal"]}",
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        );
      },
    );
  }
}

//  EMPTY STATE
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            "Belum ada resep",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            "Mulai unggah resep terbaikmu!",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
