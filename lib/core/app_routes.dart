import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/main_shell.dart';
import '../screens/dashboard_screen.dart';
import '../screens/farms_screen.dart';
import '../screens/drone_upload_screen.dart';
import '../screens/phenology_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/block_detail_screen.dart';
import '../screens/vineyard_map_screen.dart';
import '../screens/estate_select_screen.dart';
import '../screens/outcome_screen.dart';

final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    // Estate picker — shown after login/splash, before the Kokotos Estate
    // features. Lays groundwork for multiple farms in the system.
    GoRoute(
      path: '/estates',
      builder: (context, state) => const EstateSelectScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/farms',
          builder: (context, state) => const FarmsScreen(),
          routes: [
            GoRoute(
              path: ':blockId',
              builder: (context, state) => BlockDetailScreen(
                blockId: state.pathParameters['blockId'] ?? '',
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/flights',
          // Optional ?block=<id> query param — set when arriving from a
          // per-block link (Phenology diagram, block detail page) so the
          // operator lands with that block already selected.
          builder: (context, state) => DroneUploadScreen(
            initialBlockId: state.uri.queryParameters['block'],
          ),
        ),
        GoRoute(
          path: '/phenology',
          builder: (context, state) => const PhenologyScreen(),
        ),
        GoRoute(
          path: '/outcome',
          // Optional ?block=<id>&flight=<n> — set when arriving from the
          // Phenology diagram's "View NDVI image for this flight" link,
          // so the Outcome tab opens already scrolled to that block with
          // that exact flight's report selected.
          //
          // The `key` is set to the full URL (including query string) on
          // purpose: without it, Flutter can treat two visits to
          // "/outcome" with different ?flight= values as the *same*
          // widget and reuse its old state instead of rebuilding, which
          // is why tapping a different Phenology stage could otherwise
          // keep showing whichever flight was selected last time.
          // Keying by the full URL forces a fresh screen every time.
          builder: (context, state) => OutcomeScreen(
            key: ValueKey('outcome-${state.uri}'),
            initialBlockId: state.uri.queryParameters['block'],
            initialFlightNumber:
                int.tryParse(state.uri.queryParameters['flight'] ?? ''),
          ),
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    // Full-screen vineyard overview map (item 1.a) — outside the shell
    // so it renders without the bottom nav bar, like /profile.
    GoRoute(
      path: '/map',
      builder: (context, state) => const VineyardMapScreen(),
    ),
  ],
);
