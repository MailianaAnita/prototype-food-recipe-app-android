import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_makan/home/login.dart';

class HalamanPengaturan extends StatelessWidget {
  const HalamanPengaturan({super.key});

  // KONFIRMASI LOGOUT
  Future<void> _confirmLogout(BuildContext context) async {
    final parentContext = context;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text(
            "Apakah anda ingin keluar dari akun anda saat ini?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                // Logout
                await FirebaseAuth.instance.signOut();

                // Delay sebentar
                await Future.delayed(const Duration(milliseconds: 300));

                if (!parentContext.mounted) return;

                Navigator.pushAndRemoveUntil(
                  parentContext,
                  MaterialPageRoute(builder: (_) => const HalamanLogin()),
                  (route) => false,
                );
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Ganti Nama Pengguna"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _ubahNama(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text(
              "Hapus Akun",
              style: TextStyle(color: Colors.red),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.red),
            onTap: () => _hapusAkun(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Keluar Akun",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  // UBAH NAMA
  void _ubahNama(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Ubah Nama Pengguna"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "Masukkan nama baru"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () async {
                  final newName = controller.text.trim();
                  if (newName.isEmpty) return;

                  Navigator.pop(context);

                  try {
                    final user = FirebaseAuth.instance.currentUser;

                    // UPDATE DISPLAY NAME
                    await user!.updateDisplayName(newName);
                    await user.reload();

                    //  update ke halaman profil
                    FirebaseAuth.instance.authStateChanges();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Nama pengguna berhasil diperbarui"),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gagal update nama: $e")),
                    );
                  }
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
    );
  }

  // HAPUS AKUN
  void _hapusAkun(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final parentContext = context; // SIMPAN CONTEXT AWAL
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (dialogCtx) => AlertDialog(
            title: const Text("Konfirmasi Hapus Akun"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Masukkan password untuk menghapus akun."),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Password"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(dialogCtx); // tutup dialog

                  try {
                    final email = user.email!;
                    final password = passwordController.text.trim();

                    final credential = EmailAuthProvider.credential(
                      email: email,
                      password: password,
                    );

                    // WAJIB reauthenticate
                    await user.reauthenticateWithCredential(credential);

                    // Hapus akun
                    await user.delete();

                    // CEK CONTEXT MASIH HIDUP
                    if (!parentContext.mounted) return;

                    // Navigasi ke Login
                    Navigator.pushAndRemoveUntil(
                      parentContext,
                      MaterialPageRoute(builder: (_) => const HalamanLogin()),
                      (route) => false,
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(
                      parentContext,
                    ).showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
                },
                child: const Text("Hapus", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
