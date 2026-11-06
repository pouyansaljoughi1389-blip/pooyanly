import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/providers/user_provider.dart';
import 'data/local/storage_service.dart';
import 'features/onboarding/screens/splash_screen.dart';
import 'features/onboarding/screens/welcome_screen.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/placement_test/screens/placement_test_screen.dart';
import 'features/placement_test/screens/placement_result_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/lessons/screens/lesson_screen.dart';
import 'features/learning_path/screens/learning_path_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/tutor/screens/tutor_screen.dart';
import 'features/community/screens/community_screen.dart';
import 'features/listening/screens/listening_screen.dart';
import 'features/about/screens/about_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.instance.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: const PouyanlyApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (ctx, _) => const SplashScreen()),
    GoRoute(path: '/welcome', builder: (ctx, _) => const WelcomeScreen()),
    GoRoute(path: '/onboarding', builder: (ctx, _) => const OnboardingScreen()),
    GoRoute(
        path: '/placement-test',
        builder: (ctx, _) => const PlacementTestScreen()),
    GoRoute(
        path: '/placement-result',
        builder: (ctx, _) => const PlacementResultScreen()),
    GoRoute(path: '/home', builder: (ctx, _) => const HomeScreen()),
    GoRoute(
        path: '/learning-path',
        builder: (ctx, _) => const LearningPathScreen()),
    GoRoute(
        path: '/lesson/:lessonId',
        builder: (ctx, state) => LessonScreen(
            lessonId: state.pathParameters['lessonId'] ?? '')),
    GoRoute(path: '/tutor', builder: (ctx, _) => const TutorScreen()),
    GoRoute(path: '/community', builder: (ctx, _) => const CommunityScreen()),
    GoRoute(path: '/about', builder: (ctx, _) => const AboutScreen()),
    GoRoute(path: '/listening', builder: (ctx, _) => const ListeningScreen()),
    GoRoute(
        path: '/settings',
        builder: (ctx, _) => const SettingsScreen()),
  ],
);

class PouyanlyApp extends StatelessWidget {
  const PouyanlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userProv = context.watch<UserProvider>();
    return MaterialApp.router(
      title: 'POUYANLY',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode:
          userProv.user?.isDarkMode == true ? ThemeMode.dark : ThemeMode.light,
      routerConfig: _router,
      builder: (ctx, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
    );
  }
}
