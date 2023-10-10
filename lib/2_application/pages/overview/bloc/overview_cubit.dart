import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_collections.dart';
import 'package:todo_app/core/use_case.dart';

part 'overview_cubit_state.dart';

class OverviewCubit extends Cubit<OverviewCubitState> {
  OverviewCubit({
    required this.loadToDoCollections,
    OverviewCubitState? initialState,
  }) : super(initialState ?? OverviewCubitLoadingState());

  final LoadToDoCollections loadToDoCollections;

  Future<void> readToDoCollections() async {
    emit(OverviewCubitLoadingState());
    try {
      final collectionsFuture = loadToDoCollections.call(NoParams());
      final collections = await collectionsFuture;

      if (collections.isLeft) {
        emit(OverviewCubitErrorState());
      } else {
        emit(OverviewCubitLoadedState(collections: collections.right));
      }
    } on Exception {
      emit(OverviewCubitErrorState());
    }
  }
}
