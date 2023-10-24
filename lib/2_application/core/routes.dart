import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/2_application/core/go_router_observer.dart';
import 'package:todo_app/2_application/pages/create_todo_collection/create_todo_collection_page.dart';
import 'package:todo_app/2_application/pages/create_todo_entry_item/crete_todo_entry_item_page.dart';
import 'package:todo_app/2_application/pages/dashboard/dashboard_page.dart';
import 'package:todo_app/2_application/pages/detail/detail_page.dart';
import 'package:todo_app/2_application/pages/home/cubit/navigation_to_do_cubit.dart';
import 'package:todo_app/2_application/pages/home/home_page.dart';
import 'package:todo_app/2_application/pages/overview/overview_page.dart';
import 'package:todo_app/2_application/pages/settings/settings_page.dart';
import 'package:todo_app/2_application/pages/task/task_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

const String _basePath = '/home';

final routes = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '$_basePath/${DashboardPage.pageConfig.name}',
  observers: [GoRouterObserver()],
  routes: [
    GoRoute(
        name: SettingsPage.pageConfig.name,
        path: '$_basePath/${SettingsPage.pageConfig.name}',
        builder: (context, state) => SettingsPage(key: state.pageKey)),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      routes: [
        GoRoute(
          name: HomePage.pageConfig.name,
          path: '$_basePath/:tab',
          builder: (context, state) => HomePage(
            key: state.pageKey,
            tab: state.pathParameters['tab']!,
          ),
        ),
      ],
      builder: (context, state, child) => child,
    ),
    GoRoute(
      name: CreateToDoCollectionPage.pageConfig.name,
      path: '$_basePath/overview/${CreateToDoCollectionPage.pageConfig.name}',
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('create collection'),
          leading: BackButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.goNamed(
                  HomePage.pageConfig.name,
                  pathParameters: {'tab': OverviewPage.pageConfig.name},
                );
              }
            },
          ),
        ),
        body: SafeArea(child: CreateToDoCollectionPage.pageConfig.child),
      ),
    ),
    GoRoute(
      name: DetailPage.pageConfig.name,
      path: '$_basePath/overview/:collectionId',
      builder: (context, state) =>
          BlocListener<NavigationToDoCubit, NavigationToDoCubitState>(
        listenWhen: (previous, current) =>
            previous.isSecondBodyDisplayed != current.isSecondBodyDisplayed,
        listener: (context, state) {
          if (context.canPop() && (state.isSecondBodyDisplayed ?? false)) {
            context.pop();
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text('details'),
              leading: BackButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.goNamed(
                      HomePage.pageConfig.name,
                      pathParameters: {'tab': OverviewPage.pageConfig.name},
                    );
                  }
                },
              ),
            ),
            body: DetailPageProvider(
              collectionId: CollectionId.fromUniqueString(
                state.pathParameters['collectionId']!,
              ),
            )),
      ),
    ),
    GoRoute(
      name: CreateToDoEntryItemPage.pageConfig.name,
      path: '$_basePath/overview/:collectionId/add',
      builder: (context, state) =>
          BlocListener<NavigationToDoCubit, NavigationToDoCubitState>(
        listenWhen: (previous, current) =>
            previous.isSecondBodyDisplayed != current.isSecondBodyDisplayed,
        listener: (context, state) {
          if (context.canPop() && (state.isSecondBodyDisplayed ?? false)) {
            context.pop();
          }
        },
        child: CreateToDoEntryItemPageProvider(
          collectionId: CollectionId.fromUniqueString(
            state.pathParameters['collectionId']!,
          ),
          updateCollectionCallback:
              state.extra == null ? () {} : state.extra as Function,
        ),
      ),
    ),
    GoRoute(
      name: TaskPage.pageConfig.name,
      path: '$_basePath/${TaskPage.pageConfig.name}',
      builder: (context, state) => const TaskPage(),
    )
  ],
);
