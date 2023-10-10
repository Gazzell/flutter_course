part of 'navigation_to_do_cubit.dart';

class NavigationToDoCubitState extends Equatable {
  final CollectionId? selectedToDoCollectionId;
  final bool? isSecondBodyDisplayed;
  const NavigationToDoCubitState({
    this.selectedToDoCollectionId,
    this.isSecondBodyDisplayed,
  });

  @override
  List<Object?> get props => [selectedToDoCollectionId, isSecondBodyDisplayed];
}
