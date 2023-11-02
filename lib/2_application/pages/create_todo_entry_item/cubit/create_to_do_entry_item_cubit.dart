import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/use_cases/create_todo_entry_item.dart';
import 'package:todo_app/2_application/core/form_value.dart';
import 'package:todo_app/core/use_case.dart';

part 'create_to_do_entry_item_state.dart';

class CreateToDoEntryItemCubit extends Cubit<CreateToDoEntryItemState> {
  final CollectionId collectionId;
  final CreateToDoEntryItem createToDoEntryItem;
  CreateToDoEntryItemCubit({
    required this.collectionId,
    required this.createToDoEntryItem,
  }) : super(CreateToDoEntryItemInitial());

  void descriptionChanged({String? description}) {
    ValidationStatus currentStatus = ValidationStatus.pending;
    if (description == null || description.isEmpty || description.length < 2) {
      currentStatus = ValidationStatus.error;
    } else {
      currentStatus = ValidationStatus.success;
    }
    emit(state.copyWith(
      description: FormValue(
        value: description,
        validationStatus: currentStatus,
      ),
    ));
  }

  Future<void> submit() async {
    createToDoEntryItem.call(
      ToDoEntryParams(
        collectionId: collectionId,
        entry: ToDoEntry.empty().copyWith(
          description: state.description?.value,
        ),
      ),
    );
  }
}
