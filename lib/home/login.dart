import 'package:flutter/material.dart';
import '../main.dart';
import 'daftarakun.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HalamanLogin extends StatefulWidget {
  const HalamanLogin({super.key});

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _tampilkanPassword = false;
  bool _sedangMemuat = false;

  late AnimationController _controller;
  late Animation<Color?> _warna1;
  late Animation<Color?> _warna2;

  @override
  void initState() {
    super.initState();

    // Animasi background gradasi
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _warna1 = ColorTween(
      begin: Colors.orange.shade200,
      end: Colors.orange.shade500,
    ).animate(_controller);

    _warna2 = ColorTween(
      begin: Colors.orange.shade100,
      end: Colors.yellow.shade200,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _sedangMemuat = true);

    try {
      // Login dengan email & password Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      // Cek apakah email sudah diverifikasi
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email belum diverifikasi. Cek email dulu ya 📩"),
            backgroundColor: Colors.orangeAccent,
          ),
        );
        await FirebaseAuth.instance.signOut();
        return;
      }

      // Kalau berhasil login, tampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login berhasil! Selamat datang 🍲"),
          backgroundColor: Color.fromARGB(255, 242, 177, 97),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HalamanUtama()),
      );
    } on FirebaseAuthException catch (e) {
      String pesan;

      switch (e.code) {
        case 'wrong-password':
          pesan = "Password salah, coba lagi.";
          break;
        case 'invalid-email':
          pesan = "Format email nggak valid.";
          break;
        case 'network-request-failed':
          pesan = "Cek koneksi internet lo.";
          break;
        case 'user-disabled':
          pesan = "Akun ini udah dinonaktifkan.";
          break;
        case 'too-many-requests':
          pesan = "Terlalu banyak percobaan login. Coba lagi nanti.";
          break;
        case 'email-not-verified':
          pesan =
              e.message ?? "Email belum diverifikasi. Cek kotak masuk kamu ya.";
          break;
        default:
          pesan = "Login gagal: ${e.message}";
      }
      // tampilkan snackbar cuma kalau ada pesan error
      if (pesan.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(pesan), backgroundColor: Colors.redAccent),
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
                            "Selamat Datang di D’Mita!!",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Input Email
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

                          // Input Password
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

                          // Tombol Masuk
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _sedangMemuat ? null : _login,
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
                                        "Masuk",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Teks "Belum punya akun? Daftar di sini"
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Belum memiliki akun? "),
                              GestureDetector(
                                onTap: () {
                                  // Tampilkan snackbar dulu
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Menuju halaman pendaftaran...",
                                      ),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );

                                  // Lanjutkan ke halaman daftar setelah sedikit delay
                                  Future.delayed(
                                    const Duration(seconds: 1),
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  const HalamanDaftar(),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: const Text(
                                  "Daftar di sini",
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
