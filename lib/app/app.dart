import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/offline_banner.dart';
import 'app_routes.dart';
import 'app_theme.dart';

class ElssaApp extends StatelessWidget {
  const ElssaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Elssa',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: appRouter,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: MediaQuery.textScalerOf(
                  context,
                ).clamp(minScaleFactor: 0.9, maxScaleFactor: 1.3),
              ),
              child: OfflineBanner(child: child!),
            );
          },
        );
      },
    );
  }
}
