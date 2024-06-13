import 'package:chat_gemini/application/router/error/error_page.dart';
import 'package:chat_gemini/application/router/scaffold_with_nested_navigation.dart';
import 'package:chat_gemini/pages/chat/chat_page.dart';
import 'package:chat_gemini/pages/history/history_page.dart';
import 'package:chat_gemini/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorCreationalKey = GlobalKey<NavigatorState>();
final shellNavigatorStructuralKey = GlobalKey<NavigatorState>();
final shellNavigatorBehavioralKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: ChatPage.routeName,
  navigatorKey: _rootNavigatorKey,
  routes: [
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
        // second branch (B)
        StatefulShellBranch(
          navigatorKey: shellNavigatorBehavioralKey,
          routes: [
            // top route inside branch
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
            // top route inside branch
            GoRoute(
              path: ProfilePage.routeName,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ProfilePage(),
              ),
              // routes: [
              //   // child route
              //   GoRoute(
              //     path: PatternPage.routeName,
              //     pageBuilder: (context, state) {
              //       final arguments = state.extra;
              //
              //       return NoTransitionPage(
              //         child: arguments is PatternPageArguments
              //             ? PatternPage(
              //                 arguments: arguments,
              //               )
              //             : const ErrorPage(),
              //       );
              //     },
              //   ),
              // ],
            ),
          ],
        ),
      ],
    ),
  ],
);
