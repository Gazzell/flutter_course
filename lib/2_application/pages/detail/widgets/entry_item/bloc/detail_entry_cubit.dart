import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_entry.dart';
import 'package:todo_app/1_domain/use_cases/update_todo_entry_is_done.dart';
import 'package:todo_app/core/use_case.dart';

part 'detail_entry_cubit_state.dart';

class DetailEntryCubit extends Cubit<DetailEntryCubitState> {
  DetailEntryCubit({
    required this.collectionId,
    required this.entryId,
    required this.loadToDoEntry,
    required this.updateToDoEntryIsDone,
  }) : super(DetailEntryLoadingState());

  final CollectionId collectionId;
  final EntryId entryId;
  final LoadToDoEntry loadToDoEntry;
  final UpdateToDoEntryIsDone updateToDoEntryIsDone;

  Future<void> readToDoDetailEntry() async {
    try {
      final detailEntry = await loadToDoEntry(
        ToDoEntryIdsParams(
          collectionId: collectionId,
          entryId: entryId,
        ),
      );

      detailEntry.fold(
        (left) => emit(DetailEntryErrorState()),
        (right) => emit(
          DetailEntryLoadedState(entry: right),
        ),
      );
      // if (detailEntry.isLeft) {
      //   emit(DetailEntryErrorState());
      // } else {
      //   emit(DetailEntryLoadedState(entry: detailEntry.right));
      // }
    } on Exception catch (_) {
      emit(DetailEntryErrorState());
    }
  }

  Future<void> updateToDoDetailEntryIsDone(bool isDone) async {
    try {
      final updatedEntry = await updateToDoEntryIsDone(
        ToDoEntryIdsUdpateParams(
          collectionId: collectionId,
          entryId: entryId,
          isDone: isDone,
        ),
      );
      if (updatedEntry is Left) {
        emit(DetailEntryErrorState());
      } else {
        emit(DetailEntryLoadedState(entry: updatedEntry.right));
      }
    } on Exception catch (_) {
      emit(DetailEntryErrorState());
    }
  }
}
