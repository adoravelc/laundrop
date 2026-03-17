import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundrop/injection_container.dart';
import '/features/laundry_service/domain/entities/service.dart';
import '/features/laundry_service/domain/entities/service.dart';
import '/features/laundry_service/domain/get_services.dart';
import '../providers/auth_provider.dart';
import 'login_page.dart';

final servicesProvider = FutureProvider<List<Service>>((ref) async {
  final result = await sl<GetServices>().execute();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (services) => services,
  );
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Ngambil state dari authProvider untuk dapet data user yang lagi login
    final authState = ref.watch(authProvider);
    String userName = "Pelanggan";

    if (authState is AuthSuccess) {
      userName = authState.user.firstName;
    }

    // Daftar halaman untuk Bottom Navigation
    final List<Widget> pages = [
      _buildBeranda(userName),
      const Center(child: Text('Halaman Riwayat Pesanan (Coming Soon)')),
      _buildProfile(userName),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.blueAccent,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  // --- WIDGET BERANDA UTAMA ---
  Widget _buildBeranda(String userName) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header (Sapaan & Lokasi)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hai, $userName! 👋',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.redAccent,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Surabaya Barat',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 2. Banner Promo (Biar manis aja)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlue],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Diskon 20%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Khusus pengguna baru untuk layanan Dry Clean jas & blazer.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.local_offer, color: Colors.white54, size: 48),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. Judul Layanan
          const Text(
            'Layanan Kami',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // 4. Grid Katalog Layanan Dinamis
          ref
              .watch(servicesProvider)
              .when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text(
                    'Error: $error',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                data: (services) {
                  if (services.isEmpty) {
                    return const Center(
                      child: Text('Belum ada layanan tersedia.'),
                    );
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.85,
                        ),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      // Pilih icon asal beda (bisa disesuaikan nanti)
                      IconData icon =
                          service.name.toLowerCase().contains('setrika')
                          ? Icons.iron
                          : Icons.local_laundry_service;

                      // Format harga yang tadinya desimal jadi format Rupiah sederhana
                      return _buildServiceCard(
                        service.name,
                        'Rp ${service.price.toInt()} / ${service.unit}',
                        icon,
                      );
                    },
                  );
                },
              ),
        ],
      ),
    );
  }

  // Widget Card untuk Layanan
  Widget _buildServiceCard(String title, String price, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue.shade50,
            child: Icon(icon, size: 32, color: Colors.blueAccent),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ],
      ),
    );
  }

  // --- WIDGET PROFIL SEMENTARA (Buat tombol Logout) ---
  Widget _buildProfile(String userName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            userName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Keluar'),
            onPressed: () {
              // TODO: Panggil fungsi logout di Riverpod
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
