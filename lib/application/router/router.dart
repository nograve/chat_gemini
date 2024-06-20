import 'package:chat_gemini/application/router/scaffold_with_nested_navigation.dart';
import 'package:chat_gemini/pages/chat/chat_page.dart';
import 'package:chat_gemini/pages/history/history_page.dart';
import 'package:chat_gemini/pages/profile/profile_page.dart';
import 'package:chat_gemini/pages/sign_in/sign_in_page.dart';
import 'package:chat_gemini/pages/sign_up/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorCreationalKey = GlobalKey<NavigatorState>();
final shellNavigatorStructuralKey = GlobalKey<NavigatorState>();
final shellNavigatorBehavioralKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: SignInPage.routeName,
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: SignInPage.routeName,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: SignInPage(),
      ),
    ),
    GoRoute(
      path: SignUpPage.routeName,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: SignUpPage(),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: shellNavigatorCreationalKey,
          routes: [
            GoRoute(
              path: ChatPage.routeName,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ChatPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: shellNavigatorBehavioralKey,
          routes: [
            GoRoute(
              path: HistoryPage.routeName,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HistoryPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: shellNavigatorStructuralKey,
          routes: [
            GoRoute(
              path: ProfilePage.routeName,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ProfilePage(),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
