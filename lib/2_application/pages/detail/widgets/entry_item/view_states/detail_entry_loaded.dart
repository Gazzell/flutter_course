import 'package:flutter/material.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';

class DetailEntryLoaded extends StatelessWidget {
  final ToDoEntry entry;
  final Function(bool) onDoneChanged;
  final Function() onRemoved;
  const DetailEntryLoaded({
    super.key,
    required this.entry,
    required this.onDoneChanged,
    required this.onRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey.shade50,
      child: ListTile(
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () {
            onRemoved();
          },
        ),
        title: Text(entry.description),
        leading: IconButton(
          onPressed: () => onDoneChanged(!entry.isDone),
          icon: Icon(
            Icons.done_rounded,
            color: entry.isDone ? Colors.greenAccent : Colors.orangeAccent,
          ),
        ),
      ),
    );
  }
}
