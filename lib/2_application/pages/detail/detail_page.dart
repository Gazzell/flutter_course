import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_entries_collection.dart';
import 'package:todo_app/1_domain/use_cases/remove_todo_entry.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:todo_app/2_application/pages/detail/bloc/detail_cubit.dart';
import 'package:todo_app/2_application/pages/detail/view_states/detail_error.dart';
import 'package:todo_app/2_application/pages/detail/view_states/detail_loaded.dart';
import 'package:todo_app/2_application/pages/detail/view_states/detail_loading.dart';

class DetailPageProvider extends StatelessWidget {
  final CollectionId collectionId;
  const DetailPageProvider({super.key, required this.collectionId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DetailCubit>(
      create: (context) => DetailCubit(
        collectionId: collectionId,
        loadToDoEntriesCollection: LoadToDoEntriesCollection(
          toDoRepository: RepositoryProvider.of<ToDoRepository>(context),
        ),
        removeToDoEntry: RemoveToDoEntry(
          toDoRepository: RepositoryProvider.of<ToDoRepository>(context),
        ),
      )..readToDoDetail(),
      child: DetailPage(collectionId: collectionId),
    );
  }
}

class DetailPage extends StatelessWidget {
  final CollectionId collectionId;
  const DetailPage({super.key, required this.collectionId});

  static const pageConfig = PageConfig(
    icon: Icons.details_rounded,
    name: 'detail',
    child: Placeholder(),
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailCubit, DetailCubitState>(
        builder: (context, state) {
      if (state is DetailCubitLoadingState) {
        return const DetailLoading();
      } else if (state is DetailCubitLoadedState) {
        return DetailLoaded(
          collectionId: collectionId,
          entryIds: state.entryIds,
        );
      }
      return const DetailError();
    });
  }
}
