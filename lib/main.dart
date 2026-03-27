import 'dart:developer';

import 'package:ecosyncai/core/themes/app_theme.dart';
import 'package:ecosyncai/features/home/data/datasource/remote_data.dart';
import 'package:ecosyncai/features/home/data/repository/bin_repo_impl.dart';
import 'package:ecosyncai/features/home/data/repository/ward_repo_impl.dart';
import 'package:ecosyncai/features/home/presentations/bloc/bin/bin_bloc.dart';
import 'package:ecosyncai/features/home/presentations/bloc/ward/ward_bloc.dart';
import 'package:ecosyncai/features/main/presentations/screens/main_navigation_screen.dart';
import 'package:ecosyncai/features/report/data/datasource/report_remote_data.dart';
import 'package:ecosyncai/features/report/presentations/bloc/report/report_bloc.dart';
import 'package:ecosyncai/features/scanner/data/datasource/scanner_remote_data.dart';
import 'package:ecosyncai/features/scanner/data/repository/scanner_repo_impl.dart';
import 'package:ecosyncai/features/scanner/presentations/bloc/scanner/scanner_bloc.dart';
import 'package:ecosyncai/core/network/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");

    log('✅ ENV LOADED');
    log('API_BASE_URL: ${dotenv.env['API_BASE_URL']}');
  } catch (e) {
    log('❌ ENV LOAD FAILED: $e');
  }

  await Network.init();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';

  log('Token: $token');

  runApp(const EcoSyncApp());
}

class EcoSyncApp extends StatelessWidget {
  const EcoSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    final remote = RemoteDataImpl();
    final repo = BinRepoImpl(remoteData: remote);
    final wardRepo = WardRepoImpl(remoteData: remote);
    final reportRemote = ReportRemoteDataImpl();
    final scannerRemote = ScannerRemoteDataImpl();
    final scannerRepo = ScannerRepoImpl(remoteData: scannerRemote);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BinBloc(repo)),
        BlocProvider(create: (_) => WardBloc(wardRepo)),
        BlocProvider(create: (_) => ReportBloc(reportRemote)),
        BlocProvider(create: (_) => ScannerBloc(scannerRepo)),
      ],
      child: MaterialApp(
        title: 'EcoSync AI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: const MainNavigationScreen(),
      ),
    );
  }
}
