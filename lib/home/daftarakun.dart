import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HalamanDaftar extends StatefulWidget {
  const HalamanDaftar({super.key});

  @override
  State<HalamanDaftar> createState() => _HalamanDaftarState();
}

class _HalamanDaftarState extends State<HalamanDaftar>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _verifikasiController = TextEditingController();

  bool _tampilkanPassword = false;
  bool _sedangMemuat = false;

  late AnimationController _controller;
  late Animation<Color?> _warna1;
  late Animation<Color?> _warna2;

  @override
  void initState() {
    super.initState();

    // Animasi gradasi background
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _warna1 = ColorTween(
      begin: Colors.orange.shade300,
      end: Colors.deepOrange.shade400,
    ).animate(_controller);

    _warna2 = ColorTween(
      begin: Colors.yellow.shade200,
      end: Colors.orange.shade100,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _daftar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _sedangMemuat = true);

    try {
      // Buat akun Firebase baru
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      // Kirim Email Verifikasi
      await userCredential.user!.sendEmailVerification();

      //Update display name (Username)
      await userCredential.user!.updateDisplayName(
        _usernameController.text.trim(),
      );

      // Refresh data user
      await userCredential.user!.reload();

      if (!mounted) return;

      //Tampilkan notifikasi jika berhasil login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Pendaftaran berhasil! Silakan cek email untuk verifikasi, lalu login 🍲",
          ),
          backgroundColor: Color.fromARGB(255, 224, 175, 61),
          duration: Duration(seconds: 4),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String pesan = "";

      if (e.code == 'email-already-in-use') {
        pesan = "Email sudah terdaftar. Silakan login.";
      } else if (e.code == 'invalid-email') {
        pesan = "Format email tidak valid.";
      } else if (e.code == 'weak-password') {
        pesan = "Password terlalu lemah. Minimal 6 karakter.";
      } else if (e.code == 'operation-not-allowed') {
        pesan =
            "Pendaftaran dengan email/password belum diaktifkan di Firebase.";
      } else if (e.code == 'network-request-failed') {
        pesan = "Tidak ada koneksi internet.";
      } else {
        pesan = "Terjadi kesalahan. Silakan coba lagi nanti.";
      }

      // tampilkan snackbar kalau ada pesan error
      if (pesan.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(pesan), backgroundColor: Colors.redAccent),
        );
      }
      //Pindah ke halaman login

      // Jika email sudah terdaftar, arahkan ke halaman login (opsional, tapi disarankan)
      if (e.code == 'email-already-in-use') {
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HalamanLogin()),
        );
      }
    } finally {
      if (mounted) setState(() => _sedangMemuat = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _warna1.value ?? Colors.orange,
                  _warna2.value ?? Colors.yellow,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Buat Akun Baru 🍳",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Username
                          TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: "Username",
                              prefixIcon: Icon(Icons.person_outline),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Username wajib diisi";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Email
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: "Alamat Email",
                              prefixIcon: Icon(Icons.email_outlined),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email wajib diisi";
                              }
                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(value)) {
                                return "Format email tidak valid";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Password
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_tampilkanPassword,
                            decoration: InputDecoration(
                              labelText: "Kata Sandi",
                              prefixIcon: const Icon(Icons.lock_outline),
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _tampilkanPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _tampilkanPassword = !_tampilkanPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Kata sandi wajib diisi";
                              }
                              if (value.length < 6) {
                                return "Minimal 6 karakter";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // Verifikasi Password
                          TextFormField(
                            controller: _verifikasiController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Verifikasi Kata Sandi",
                              prefixIcon: Icon(Icons.lock_person_outlined),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return "Kata sandi tidak sama";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // Tombol Daftar
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _sedangMemuat ? null : _daftar,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child:
                                  _sedangMemuat
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : const Text(
                                        "Daftar",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Teks kembali ke login
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Sudah punya akun? "),
                              GestureDetector(
                                onTap: () async {
                                  // Tampilkan snackbar dulu
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Menuju halaman login..."),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );

                                  // Tunggu 1 detik
                                  await Future.delayed(
                                    const Duration(seconds: 1),
                                  );

                                  // Pastikan widget masih aktif
                                  if (!mounted) return;

                                  // Balik ke halaman login
                                  Navigator.pop(context);
                                },

                                child: const Text(
                                  "Masuk di sini",
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
