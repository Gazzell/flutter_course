import 'package:either_dart/either.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/core/use_case.dart';

class LoadToDoEntriesCollection
    implements UseCase<List<EntryId>, ToDoEntriesCollectionParams> {
  final ToDoRepository toDoRepository;

  LoadToDoEntriesCollection({required this.toDoRepository});

  @override
  Future<Either<Failure, List<EntryId>>> call(
      ToDoEntriesCollectionParams params) async {
    try {
      final entriesCollection =
          await toDoRepository.readTodoEntriesCollection(params.collectionId);
      return entriesCollection.fold(
          (left) => Left(left), (right) => Right(right));
    } on Exception catch (e) {
      return Left(ServerFailure(stackTrace: e.toString()));
    }
  }
}
