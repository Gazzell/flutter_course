part of 'navigation_to_do_cubit.dart';

class NavigationToDoCubitState extends Equatable {
  final CollectionId? selectedToDoCollectionId;
  final bool? isSecondBodyDisplayed;
  final bool? isCreatingItem;
  const NavigationToDoCubitState({
    this.selectedToDoCollectionId,
    this.isSecondBodyDisplayed,
    this.isCreatingItem,
  });

  @override
  List<Object?> get props => [
        selectedToDoCollectionId,
        isSecondBodyDisplayed,
        isCreatingItem,
      ];
}
