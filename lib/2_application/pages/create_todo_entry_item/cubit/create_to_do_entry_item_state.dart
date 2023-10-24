part of 'create_to_do_entry_item_cubit.dart';

class CreateToDoEntryItemState extends Equatable {
  final FormValue<String?>? description;

  const CreateToDoEntryItemState({this.description});

  CreateToDoEntryItemState copyWith({FormValue<String?>? description}) {
    return CreateToDoEntryItemState(
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [description];
}

final class CreateToDoEntryItemInitial extends CreateToDoEntryItemState {}
