import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_entry.dart';
import 'package:todo_app/1_domain/use_cases/update_todo_entry_is_done.dart';
import 'package:todo_app/2_application/pages/detail/widgets/entry_item/bloc/detail_entry_cubit.dart';
import 'package:todo_app/2_application/pages/detail/widgets/entry_item/view_states/detail_entry_error.dart';
import 'package:todo_app/2_application/pages/detail/widgets/entry_item/view_states/detail_entry_loaded.dart';
import 'package:todo_app/2_application/pages/detail/widgets/entry_item/view_states/detail_entry_loading.dart';

class DetailEntryProvider extends StatelessWidget {
  final CollectionId collectionId;
  final EntryId entryId;
  final Function() onRemoved;
  const DetailEntryProvider({
    super.key,
    required this.collectionId,
    required this.entryId,
    required this.onRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DetailEntryCubit>(
      create: (context) {
        final toDoRepository = RepositoryProvider.of<ToDoRepository>(context);
        return DetailEntryCubit(
          collectionId: collectionId,
          entryId: entryId,
          loadToDoEntry: LoadToDoEntry(toDoRepository: toDoRepository),
          updateToDoEntryIsDone: UpdateToDoEntryIsDone(
            toDoRepository: toDoRepository,
          ),
        )..readToDoDetailEntry();
      },
      child: EntryItem(
        collectionId: collectionId,
        entryId: entryId,
        onRemoved: onRemoved,
      ),
    );
  }
}

class EntryItem extends StatelessWidget {
  final EntryId entryId;
  final CollectionId collectionId;
  final Function() onRemoved;
  const EntryItem({
    super.key,
    required this.collectionId,
    required this.entryId,
    required this.onRemoved,
  });

  _getOnEntryDoneChanged(BuildContext context) {
    return (value) {
      context.read<DetailEntryCubit>().updateToDoDetailEntryIsDone(value);
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailEntryCubit, DetailEntryCubitState>(
      builder: (context, state) {
        if (state is DetailEntryLoadingState) {
          return const DetailEntryLoading();
        } else if (state is DetailEntryLoadedState) {
          return DetailEntryLoaded(
            entry: state.entry,
            onDoneChanged: _getOnEntryDoneChanged(context),
            onRemoved: onRemoved,
          );
        }
        return DetailEntryError(onClicked: () {
          context.read<DetailEntryCubit>().readToDoDetailEntry();
        });
      },
    );
  }
}
