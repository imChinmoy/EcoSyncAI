import 'dart:developer';

import 'package:ecosyncai/core/locale/app_locale_scope.dart';
import 'package:ecosyncai/core/locale/app_localizations.dart';
import 'package:ecosyncai/core/locale/locale_controller.dart';
import 'package:ecosyncai/core/themes/app_theme.dart';
import 'package:ecosyncai/features/auth/presentations/screens/login_screen.dart';
import 'package:ecosyncai/features/auth/presentations/screens/role_selection_screen.dart';
import 'package:ecosyncai/features/driver/data/datasource/driver_dummy_datasource.dart';
import 'package:ecosyncai/features/driver/data/repository/driver_repository_impl.dart';
import 'package:ecosyncai/features/driver/domain/usecases/get_driver_task_detail.dart';
import 'package:ecosyncai/features/driver/presentations/bloc/driver/driver_bloc.dart';
import 'package:ecosyncai/features/home/data/datasource/remote_data.dart';
import 'package:ecosyncai/features/home/data/repository/bin_repo_impl.dart';
import 'package:ecosyncai/features/home/data/repository/ward_repo_impl.dart';
import 'package:ecosyncai/features/home/presentations/bloc/bin/bin_bloc.dart';
import 'package:ecosyncai/features/home/presentations/bloc/ward/ward_bloc.dart';
import 'package:ecosyncai/features/splash/presentations/screens/splash_screen.dart';
import 'package:ecosyncai/features/report/data/datasource/report_remote_data.dart';
import 'package:ecosyncai/features/report/presentations/bloc/report/report_bloc.dart';
import 'package:ecosyncai/features/scanner/data/datasource/scanner_remote_data.dart';
import 'package:ecosyncai/features/scanner/data/repository/scanner_repo_impl.dart';
import 'package:ecosyncai/features/scanner/presentations/bloc/scanner/scanner_bloc.dart';
import 'package:ecosyncai/core/network/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

  final localeController = LocaleController();
  await localeController.load();

  runApp(EcoSyncApp(localeController: localeController));
}

class EcoSyncApp extends StatelessWidget {
  const EcoSyncApp({super.key, required this.localeController});

  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    final remoteData = RemoteDataImpl();
    final binRepo = BinRepoImpl(remoteData: remoteData);
    final wardRepo = WardRepoImpl(remoteData: remoteData);
    final reportRemote = ReportRemoteDataImpl();
    final scannerRemote = ScannerRemoteDataImpl();
    final scannerRepo = ScannerRepoImpl(remoteData: scannerRemote);
    final driverDataSource = DriverDummyDataSource();
    final driverRepo = DriverRepositoryImpl(driverDataSource);
    final getDriverTaskDetail = GetDriverTaskDetail(driverRepo);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BinBloc(binRepo)),
        BlocProvider(create: (_) => WardBloc(wardRepo)),
        BlocProvider(create: (_) => ReportBloc(reportRemote)),
        BlocProvider(create: (_) => ScannerBloc(scannerRepo)),
        BlocProvider(
          create: (_) => DriverBloc(getDriverTaskDetail: getDriverTaskDetail),
        ),
      ],
      child: AppLocaleScope(
        controller: localeController,
        child: ListenableBuilder(
          listenable: localeController,
          builder: (context, _) {
            return MaterialApp(
              title: 'EcoSyncAI',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.darkTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.dark,
              locale: localeController.locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: const RoleSelectionScreen(),
            );
          },
        ),
      ),
    );
  }
}
