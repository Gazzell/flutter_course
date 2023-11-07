import 'package:either_dart/either.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/core/use_case.dart';

class RemoveToDoEntry implements UseCase<bool, ToDoEntryIdsParams> {
  final ToDoRepository toDoRepository;
  const RemoveToDoEntry({required this.toDoRepository});

  @override
  Future<Either<Failure, bool>> call(ToDoEntryIdsParams params) async {
    try {
      final loadedEntry =
          toDoRepository.removeTodoEntry(params.collectionId, params.entryId);
      return loadedEntry.fold((left) => Left(left), (right) => Right(right));
    } on Exception catch (e) {
      return Left(ServerFailure(stackTrace: e.toString()));
    }
  }
}