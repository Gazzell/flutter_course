import 'package:either_dart/either.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/core/use_case.dart';

class CreateToDoCollection implements UseCase<bool, ToDoCollectionParams> {
  final ToDoRepository toDoRepository;

  CreateToDoCollection({required this.toDoRepository});

  @override
  Future<Either<Failure, bool>> call(ToDoCollectionParams params) async {
    try {
      final result = toDoRepository.createTodoCollection(params.collection);
      return result.fold((left) => Left(left), (right) => Right(right));
    } on Exception catch (e) {
      return Left(ServerFailure(stackTrace: e.toString()));
    }
  }
}
