import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Profile & Counter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const RootPage(),
    );
  }
}


class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {

  int _selectedIndex = 0;

  final _pages = const [ProfilePage(), CounterPage()];

  void _onNavTap(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Counter'),
        ],
      ),
    );
  }
}

// 1) Profile Page (StatelessWidget)
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Mahasiswa', style: GoogleFonts.poppins()),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              const FlutterLogo(size: 100),
              const SizedBox(height: 12),
    
              const ProfileImage(size: 140, assetPath: 'assets/profile.jpg'),
              const SizedBox(height: 16),
              Text('Husein Fadhlullah', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text('NIM: 2341760134', style: GoogleFonts.poppins(fontSize: 16)),
              const SizedBox(height: 6),
              Text('Jurusan: Teknologi Informasi', style: GoogleFonts.poppins(fontSize: 16)),
              const SizedBox(height: 16),

              const ContactRow(email: 'husein@example.com', phone: '+62 812-3456-7890'),

              const SizedBox(height: 24),
              InfoCard(text: 'Hobi: Coding, membaca, dan mengerjakan tugas mobile.'),
            ],
          ),
        ),
      ),
    );
  }
}


class ProfileImage extends StatelessWidget {
  final double size;
  final String assetPath;

  const ProfileImage({super.key, required this.size, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.hardEdge,
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(child: Icon(Icons.person, size: size * 0.5, color: Colors.grey.shade600));
        },
      ),
    );
  }
}

class ContactRow extends StatelessWidget {
  final String email;
  final String phone;

  const ContactRow({super.key, required this.email, required this.phone});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.email, color: color),
        const SizedBox(width: 8),
        Text(email, style: GoogleFonts.poppins()),
        const SizedBox(width: 24),
        Icon(Icons.phone, color: color),
        const SizedBox(width: 8),
        Text(phone, style: GoogleFonts.poppins()),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  final String text;

  const InfoCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: GoogleFonts.poppins(), textAlign: TextAlign.center),
    );
  }
}

// 2) Counter Page (StatefulWidget)
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;

  void _increment() => setState(() => _count++);
  void _decrement() => setState(() => _count--);
  void _reset() => setState(() => _count = 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter App', style: GoogleFonts.poppins())),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Angka saat ini:', style: GoogleFonts.poppins(fontSize: 18)),
            const SizedBox(height: 8),
            Text('$_count', style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.w700)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _increment,
                  child: const Text('+', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _decrement,
                  child: const Text('-', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _reset,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        tooltip: 'Tambah',
        child: const Icon(Icons.add),
      ),
    );
  }
}
