part of 'detail_cubit.dart';

sealed class DetailCubitState extends Equatable {
  const DetailCubitState();

  @override
  List<Object> get props => [];
}

final class DetailCubitLoadingState extends DetailCubitState {}

final class DetailCubitErrorState extends DetailCubitState {}

final class DetailCubitLoadedState extends DetailCubitState {
  final List<EntryId> entryIds;
  const DetailCubitLoadedState({required this.entryIds});

  @override
  List<Object> get props => [entryIds];
}
