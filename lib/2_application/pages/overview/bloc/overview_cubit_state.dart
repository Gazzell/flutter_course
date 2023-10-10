part of 'overview_cubit.dart';

sealed class OverviewCubitState extends Equatable {
  const OverviewCubitState();

  @override
  List<Object> get props => [];
}

final class OverviewCubitLoadingState extends OverviewCubitState {}

final class OverviewCubitErrorState extends OverviewCubitState {}

final class OverviewCubitLoadedState extends OverviewCubitState {
  final List<ToDoCollection> collections;
  const OverviewCubitLoadedState({required this.collections});

  @override
  List<Object> get props => [collections];
}
