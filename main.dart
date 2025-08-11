import 'package:flutter/material.dart';
import 'package:laporan_keuangan1/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'dashboard/dashboard_admin.dart';
import 'dashboard/dashboard_cabang.dart';
import 'dashboard/dashboard_staff.dart';
import 'pages/omzet_page.dart';
import 'InputBahanPokokPage.dart';
import 'InputLabaBersihPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  await Supabase.initialize(
    url:
    'https://bgkevrxaodhihleiqqqg.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJna2V2cnhhb2RoaWhsZWlxcXFnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI2MjU0NTcsImV4cCI6MjA2ODIwMTQ1N30.hjsXcsRwUqfUtLqSCRUaHnJ_ItNygDOHrXDx8U8DtMo', // Ganti dengan anon key kamu
  );

  runApp(const SimpangRayaApp());
}

class SimpangRayaApp extends StatelessWidget {
  const SimpangRayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Keuangan Simpang Raya',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorSchemeSeed: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(), // Splash screen jadi halaman pertama
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard-admin': (context) => const DashboardAdmin(),
        '/dashboard-cabang': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return DashboardCabang(
            idCabang: args['idCabang']!,
            namaCabang: args['namaCabang']!,
          );
        },
        '/dashboard_staff': (context) => const DashboardStaff(),
        '/omzet': (context) => const OmzetPage(),
        '/input-laba': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

          if (args == null) {
            return const Scaffold(
              body: Center(child: Text('Argument tidak ditemukan')),
            );
          }

          return InputLabaBersihPage(
            tanggal: args['tanggal'],
          );
        },
        '/input-omzet': (context) {
          final cabangId = Supabase.instance.client.auth.currentUser?.userMetadata?['cabang_id'] ?? 'cabang-default';
          return InputBahanPokokPage(cabangId: cabangId);
        },
      },
    );
  }
}
