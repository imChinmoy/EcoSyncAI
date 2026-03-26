import 'package:ecosyncai/core/themes/app_theme.dart';
import 'package:ecosyncai/dummy_data/services/mock_bin_service.dart';
import 'package:ecosyncai/features/home/presentations/bloc/bin/bin_bloc.dart';
import 'package:ecosyncai/features/home/presentations/bloc/ward/ward_bloc.dart';
import 'package:ecosyncai/features/main/presentations/screens/main_navigation_screen.dart';
import 'package:ecosyncai/features/report/presentations/bloc/report/report_bloc.dart';
import 'package:ecosyncai/core/network/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Network.init();
  await SharedPreferences.getInstance().then((value) => value.getString('token') ?? '');
  runApp(const EcoSyncApp());

}

class EcoSyncApp extends StatelessWidget {
  const EcoSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MockBinService is injected here.
    // To plug in a real backend: replace MockBinService() with RealBinService()
    // that implements the same BinService interface.
    final binService = MockBinService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BinBloc(binService)),
        BlocProvider(create: (_) => WardBloc()),
        BlocProvider(create: (_) => ReportBloc(binService)),
      ],
      child: MaterialApp(
        title: 'EcoSync AI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavigationScreen(),
      ),
    );
  }
}
