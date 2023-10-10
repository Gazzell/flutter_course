import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';

part 'navigation_to_do_cubit_state.dart';

class NavigationToDoCubit extends Cubit<NavigationToDoCubitState> {
  NavigationToDoCubit() : super(const NavigationToDoCubitState());

  void selectedToDoCollectionChanged(CollectionId collectionId) {
    emit(NavigationToDoCubitState(selectedToDoCollectionId: collectionId));
  }

  void secondBodyHasChanged({required bool isSecondBodyDisplayed}) {
    if (state.isSecondBodyDisplayed != isSecondBodyDisplayed) {
      emit(
        NavigationToDoCubitState(
          isSecondBodyDisplayed: isSecondBodyDisplayed,
          selectedToDoCollectionId: state.selectedToDoCollectionId,
        ),
      );
    }
  }
}
