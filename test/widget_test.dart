import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:elssa/app/app_theme.dart';
import 'package:elssa/app/constants.dart';
import 'package:elssa/features/auth/providers/auth_provider.dart';
import 'package:elssa/features/splash/presentation/splash_screen.dart';

void main() {
  testWidgets('App renders splash screen with logo at startup', (
    WidgetTester tester,
  ) async {
    // authStateProvider is overridden so this test never touches real
    // Firebase, which isn't initialized in the widget-test environment.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => const Stream.empty()),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => MaterialApp.router(
            theme: AppTheme.light,
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
                GoRoute(path: '/login', builder: (_, _) => const SizedBox()),
                GoRoute(path: '/home', builder: (_, _) => const SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final logoFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName == AppAssets.logo,
    );
    expect(logoFinder, findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 3));
  });
}
