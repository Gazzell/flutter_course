import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_entries_collection.dart';
import 'package:todo_app/core/use_case.dart';

part 'detail_cubit_state.dart';

class DetailCubit extends Cubit<DetailCubitState> {
  DetailCubit({
    required this.collectionId,
    required this.loadToDoEntriesCollection,
  }) : super(DetailCubitLoadingState());

  final CollectionId collectionId;
  final LoadToDoEntriesCollection loadToDoEntriesCollection;

  Future<void> readToDoDetail() async {
    try {
      final entryIds = await loadToDoEntriesCollection.call(
        ToDoEntriesCollectionParams(collectionId: collectionId),
      );

      if (entryIds.isLeft) {
        emit(DetailCubitErrorState());
      } else {
        emit(DetailCubitLoadedState(entryIds: entryIds.right));
      }
    } on Exception catch (_) {
      emit(DetailCubitErrorState());
    }
  }
}
