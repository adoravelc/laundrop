import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'injection_container.dart' as di;
import 'features/auth/presentation/screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  // Bungkus MyApp dengan ProviderScope
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundrop',
      debugShowCheckedModeBanner:
          false, // Menghilangkan pita "DEBUG" di pojok kanan atas
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      // Sementara kita arahkan ke halaman login dulu sebelum bikin UI Login beneran
      home: const LoginPage(),
    );
  }
}
