part of 'detail_entry_cubit.dart';

sealed class DetailEntryCubitState extends Equatable {
  const DetailEntryCubitState();

  @override
  List<Object> get props => [];
}

final class DetailEntryLoadingState extends DetailEntryCubitState {}

final class DetailEntryErrorState extends DetailEntryCubitState {}

final class DetailEntryLoadedState extends DetailEntryCubitState {
  final ToDoEntry entry;
  const DetailEntryLoadedState({required this.entry});

  @override
  List<Object> get props => [entry];
}

final class DetailEntryUpdatedState extends DetailEntryCubitState {
  final ToDoEntry entry;
  const DetailEntryUpdatedState({required this.entry});

  @override
  List<Object> get props => [entry];
}
