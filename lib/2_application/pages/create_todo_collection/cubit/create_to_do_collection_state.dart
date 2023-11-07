part of 'create_to_do_collection_cubit.dart';

class CreateToDoCollectionState extends Equatable {
  final String? title;
  final int color;
  const CreateToDoCollectionState({this.title, required this.color});

  CreateToDoCollectionState copyWith({String? title, int? color}) {
    return CreateToDoCollectionState(
      color: color ?? this.color,
      title: title ?? this.title,
    );
  }

  @override
  List<Object?> get props => [title, color];
}