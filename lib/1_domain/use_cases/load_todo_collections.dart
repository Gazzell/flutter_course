import 'package:either_dart/either.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/core/use_case.dart';

class LoadToDoCollections implements UseCase<List<ToDoCollection>, Params> {
  final ToDoRepository toDoRepository;
  const LoadToDoCollections({required this.toDoRepository});

  @override
  Future<Either<Failure, List<ToDoCollection>>> call(Params params) async {
    try {
      final loadedCollection = toDoRepository.readTodoCollections();
      return loadedCollection.fold((left) => Left(left), (right) => Right(right),);
    } on Exception catch (e) {
      return Left(ServerFailure(stackTrace: e.toString()));
    }
  }
}
