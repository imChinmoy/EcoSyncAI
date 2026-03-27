import 'package:ecosyncai/core/themes/app_theme.dart';
import 'package:ecosyncai/dummy_data/services/mock_bin_service.dart';
import 'package:ecosyncai/features/home/presentations/bloc/bin/bin_bloc.dart';
import 'package:ecosyncai/features/home/presentations/bloc/ward/ward_bloc.dart';
import 'package:ecosyncai/features/auth/presentations/screens/role_selection_screen.dart';
import 'package:ecosyncai/features/driver/data/datasource/driver_dummy_datasource.dart';
import 'package:ecosyncai/features/driver/data/repository/driver_repository_impl.dart';
import 'package:ecosyncai/features/driver/domain/usecases/get_driver_task_detail.dart';
import 'package:ecosyncai/features/driver/presentations/bloc/driver/driver_bloc.dart';
import 'package:ecosyncai/features/driver/presentations/screens/driver_task_detail_screen.dart';
import 'package:ecosyncai/features/main/presentations/screens/main_navigation_screen.dart';
import 'package:ecosyncai/features/report/presentations/bloc/report/report_bloc.dart';
import 'package:ecosyncai/features/scanner/presentations/bloc/scanner/scanner_bloc.dart';
import 'package:ecosyncai/core/network/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Network.init();
  await SharedPreferences.getInstance().then(
    (value) => value.getString('token') ?? '',
  );
  runApp(const EcoSyncApp());
}

class EcoSyncApp extends StatelessWidget {
  const EcoSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    final binService = MockBinService();

    // Driver feature dependencies
    final driverDataSource = DriverDummyDataSource();
    final driverRepository = DriverRepositoryImpl(driverDataSource);
    final getDriverTaskDetail = GetDriverTaskDetail(driverRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BinBloc(binService)),
        BlocProvider(create: (_) => WardBloc()),
        BlocProvider(create: (_) => ReportBloc(binService)),
        BlocProvider(create: (_) => ScannerBloc()),
      ],
      child: MaterialApp(
        title: 'EcoSync AI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const RoleSelectionScreen(),
          '/user_home': (context) => const MainNavigationScreen(),
          '/driver_home': (context) => BlocProvider(
            create: (_) => DriverBloc(getDriverTaskDetail: getDriverTaskDetail),
            child: const DriverTaskDetailScreen(binId: 'BIN-0942-X'),
          ),
        },
      ),
    );
  }
}
