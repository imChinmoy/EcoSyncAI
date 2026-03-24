import 'package:ecosyncai/core/themes/app_theme.dart';
import 'package:ecosyncai/dummy_data/services/mock_bin_service.dart';
import 'package:ecosyncai/features/home/presentations/providers/bin_provider.dart';
import 'package:ecosyncai/features/home/presentations/providers/ward_provider.dart';
import 'package:ecosyncai/features/home/presentations/screens/home_screen.dart';
import 'package:ecosyncai/features/report/presentations/providers/report_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecosyncai/core/network/network.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Network.init();
  await SharedPreferences.getInstance().then((value) => value.getString('token') ?? '');
  runApp(const MyApp());

}

class EcoSyncApp extends StatelessWidget {
  const EcoSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MockBinService is injected here.
    // To plug in a real backend: replace MockBinService() with RealBinService()
    // that implements the same BinService interface.
    final binService = MockBinService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BinProvider(binService)),
        ChangeNotifierProvider(create: (_) => WardProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider(binService)),
      ],
      child: MaterialApp(
        title: 'EcoSync AI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}