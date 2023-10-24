import 'package:either_dart/either.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/core/use_case.dart';

class CreateToDoEntryItem implements UseCase<bool, ToDoEntryParams> {
  final ToDoRepository toDoRepository;

  CreateToDoEntryItem({required this.toDoRepository});

  @override
  Future<Either<Failure, bool>> call(ToDoEntryParams params) async {
    try {
      final result = toDoRepository.createTodoEntryItem(params.entry.collectionId, params.entry);
      return result.fold((left) => Left(left), (right) => Right(right));
    } on Exception catch (e) {
      return Left(ServerFailure(stackTrace: e.toString()));
    }
  }
}
