import 'package:flutter/material.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';

class DetailEntryLoaded extends StatelessWidget {
  final ToDoEntry entry;
  final Function(bool) onDoneChanged;
  const DetailEntryLoaded({super.key, required this.entry, required this.onDoneChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey.shade50,
      child: ListTile(
        title: Text(entry.description),
        trailing: IconButton(
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
