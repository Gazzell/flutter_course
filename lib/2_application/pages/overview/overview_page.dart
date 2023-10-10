import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_collections.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:todo_app/2_application/pages/overview/bloc/overview_cubit.dart';
import 'package:todo_app/2_application/pages/overview/view_states/overview_error.dart';
import 'package:todo_app/2_application/pages/overview/view_states/overview_loaded.dart';
import 'package:todo_app/2_application/pages/overview/view_states/overview_loading.dart';

class OverviewPageProvider extends StatelessWidget {
  const OverviewPageProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OverviewCubit(
        loadToDoCollections: LoadToDoCollections(
          toDoRepository: RepositoryProvider.of(context),
        ),
      )..readToDoCollections(),
      child: const OverviewPage(),
    );
  }
}

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  static const pageConfig = PageConfig(
    icon: Icons.work_history_rounded,
    name: 'overview',
    child: OverviewPageProvider(),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      child: BlocBuilder<OverviewCubit, OverviewCubitState>(
        builder: (context, state) {
          if (state is OverviewCubitLoadingState) {
            return const OverviewLoading();
          } else if (state is OverviewCubitLoadedState) {
            return OverviewLoaded(collections: state.collections);
          } else {
            return const OverviewError();
          }
        },
      ),
    );
  }
}
