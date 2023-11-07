import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/entities/todo_color.dart';
import 'package:todo_app/1_domain/use_cases/create_todo_collection.dart';
import 'package:todo_app/core/use_case.dart';

part 'create_to_do_collection_state.dart';

class CreateToDoCollectionCubit extends Cubit<CreateToDoCollectionState> {
  final CreateToDoCollection createToDoCollection;

  CreateToDoCollectionCubit({required this.createToDoCollection, required int initialColor})
      : super(CreateToDoCollectionState(color: initialColor));

  void titleChanged(String title) {
    emit(state.copyWith(title: title));
  }

  void colorChanged(int color) {
    emit(state.copyWith(color: color));
  }

  Future<void> submit() async {
    await createToDoCollection.call(
      ToDoCollectionParams(
        collection: ToDoCollection.empty().copyWith(
          title: state.title,
          color: ToDoColor(value: state.color),
        ),
      ),
    );
  }
}
