import 'package:either_dart/either.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/core/use_case.dart';

class UpdateToDoEntryIsDone
    implements UseCase<ToDoEntry, ToDoEntryIdsUdpateParams> {
  final ToDoRepository toDoRepository;
  UpdateToDoEntryIsDone({required this.toDoRepository});

  @override
  Future<Either<Failure, ToDoEntry>> call(
      ToDoEntryIdsUdpateParams params) async {
    try {
      final entry = toDoRepository.updateTodoEntryIsDone(
        params.collectionId,
        params.entryId,
        params.isDone,
      );
      return entry.fold((left) => Left(left), (right) => Right(right));
    } on Exception catch (e) {
      return Left(ServerFailure(stackTrace: e.toString()));
    }
  }
}
