import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:todo_app/2_application/pages/create_todo_collection/create_todo_collection_page.dart';
import 'package:todo_app/2_application/pages/create_todo_entry_item/crete_todo_entry_item_page.dart';
import 'package:todo_app/2_application/pages/dashboard/dashboard_page.dart';
import 'package:todo_app/2_application/pages/detail/detail_page.dart';
import 'package:todo_app/2_application/pages/home/cubit/navigation_to_do_cubit.dart';
import 'package:todo_app/2_application/pages/overview/overview_page.dart';
import 'package:todo_app/2_application/pages/settings/settings_page.dart';
import 'package:todo_app/2_application/pages/task/task_page.dart';

class HomePageProvider extends StatelessWidget {
  final String tab;
  const HomePageProvider({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NavigationToDoCubit>(
      create: (_) => NavigationToDoCubit(),
      child: HomePage(tab: tab),
    );
  }
}

class HomePage extends StatefulWidget {
  final int index;

  HomePage({super.key, required String tab})
      : index = tabs.indexWhere((element) => element.name == tab);

  static const pageConfig = PageConfig(
    icon: Icons.home_rounded,
    name: 'home',
  );

  static const tabs = [
    DashboardPage.pageConfig,
    OverviewPage.pageConfig,
    TaskPage.pageConfig,
  ];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final destinations = HomePage.tabs.map(
    (page) => NavigationDestination(
      icon: Icon(page.icon),
      label: page.name,
    ),
  );

  void _onTapNavigationDestination(BuildContext context, int index) {
    context.goNamed(
      HomePage.pageConfig.name,
      pathParameters: {'tab': HomePage.tabs[index].name},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: AdaptiveLayout(
          primaryNavigation: SlotLayout(
            config: <Breakpoint, SlotLayoutConfig>{
              Breakpoints.mediumAndUp: SlotLayout.from(
                key: const Key('primary-navigation-medium'),
                builder: (context) => AdaptiveScaffold.standardNavigationRail(
                  leading: IconButton(
                    onPressed: () {
                      context
                          .pushNamed(CreateToDoCollectionPage.pageConfig.name);
                    },
                    icon: Icon(CreateToDoCollectionPage.pageConfig.icon),
                    tooltip: 'Add Collection',
                  ),
                  trailing: IconButton(
                    onPressed: () =>
                        context.pushNamed(SettingsPage.pageConfig.name),
                    icon: Icon(SettingsPage.pageConfig.icon),
                  ),
                  selectedLabelTextStyle: TextStyle(
                    color: theme.colorScheme.onBackground,
                  ),
                  selectedIconTheme: IconThemeData(
                    color: theme.colorScheme.onBackground,
                  ),
                  unselectedIconTheme: IconThemeData(
                    color: theme.colorScheme.onBackground.withOpacity(0.5),
                  ),
                  destinations: destinations
                      .map(
                        (destination) =>
                            AdaptiveScaffold.toRailDestination(destination),
                      )
                      .toList(),
                  onDestinationSelected: (index) =>
                      _onTapNavigationDestination(context, index),
                  selectedIndex: widget.index,
                ),
              ),
            },
          ),
          bottomNavigation: SlotLayout(
            config: <Breakpoint, SlotLayoutConfig>{
              Breakpoints.small: SlotLayout.from(
                key: const Key('primary-navigation-small'),
                builder: (_) => AdaptiveScaffold.standardBottomNavigationBar(
                  destinations: destinations.toList(),
                  onDestinationSelected: (index) =>
                      _onTapNavigationDestination(context, index),
                  currentIndex: widget.index,
                ),
              ),
            },
          ),
          body: SlotLayout(
            config: <Breakpoint, SlotLayoutConfig>{
              Breakpoints.smallAndUp: SlotLayout.from(
                key: const Key('primary-body-small'),
                builder: (_) => HomePage.tabs[widget.index].child,
              ),
            },
          ),
          secondaryBody: SlotLayout(
            config: <Breakpoint, SlotLayoutConfig>{
              Breakpoints.mediumAndUp: SlotLayout.from(
                key: const Key('secondary-body-medium'),
                builder: widget.index != 1
                    ? null
                    : (_) => BlocBuilder<NavigationToDoCubit,
                            NavigationToDoCubitState>(
                          builder: (context, state) {
                            final selectedToDoCollectionId =
                                state.selectedToDoCollectionId;
                            final isSecondBodyDisplayed =
                                Breakpoints.mediumAndUp.isActive(context);
                            context
                                .read<NavigationToDoCubit>()
                                .secondBodyHasChanged(
                                    isSecondBodyDisplayed:
                                        isSecondBodyDisplayed);
                            if (selectedToDoCollectionId == null) {
                              return const Placeholder();
                            }
                            if (state.isCreatingItem == true) {
                              return CreateToDoEntryItemPage(collectionId: selectedToDoCollectionId);
                            }
                            return DetailPageProvider(
                              key: Key(selectedToDoCollectionId.value),
                              collectionId: selectedToDoCollectionId,
                            );
                          },
                        ),
              ),
            },
          ),
        ),
      ),
    );
  }
}
