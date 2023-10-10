import 'package:flutter/material.dart';

class DetailEntryError extends StatelessWidget {
  final Function() onClicked;
  const DetailEntryError({super.key, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClicked,
      child: Card(
        color: Colors.red.shade100,
        child: const ListTile(title: Text('Could not load item!')),
      ),
    );
  }
}
