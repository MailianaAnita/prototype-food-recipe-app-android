import 'package:flutter/material.dart';
import 'package:recipe_makan/screens/tambah_postingan.dart';
import 'screens/home.dart';
import 'screens/riwayat.dart';
import 'screens/profile.dart';
import 'home/login.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase
  await Supabase.initialize(
    url: 'https://lmwhqpiwijjlrskvtkkj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxtd2hxcGl3aWpqbHJza3Z0a2tqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM4ODM5NzAsImV4cCI6MjA3OTQ1OTk3MH0.e9YmWXF42F347NjgpVEwKtoUDh6ctFJdxjfs2U32CIY',
  );

  // Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Cek user login
  final user = FirebaseAuth.instance.currentUser;
  final bool isLoggedIn = user != null && user.emailVerified;

  runApp(AplikasiResep(isLoggedIn: isLoggedIn));
}

class AplikasiResep extends StatelessWidget {
  final bool isLoggedIn;
  const AplikasiResep({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Resep Makanan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: isLoggedIn ? const HalamanUtama() : const HalamanLogin(),
    );
  }
}

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int menuAktif = 0;

  final List<Widget> halaman = const [
    HalamanBeranda(),
    RiwayatScreen(),
    HalamanTambahPostingan(),
    HalamanProfil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: halaman[menuAktif],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: menuAktif,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            menuAktif = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: "Upload"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
