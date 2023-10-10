import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/2_application/pages/detail/bloc/detail_cubit.dart';
import 'package:todo_app/2_application/pages/detail/widgets/entry_item/entry_item.dart';

class DetailLoaded extends StatelessWidget {
  final List<EntryId> entryIds;
  final CollectionId collectionId;

  const DetailLoaded({
    super.key,
    required this.collectionId,
    required this.entryIds,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: entryIds.length,
                itemBuilder: (context, index) => DetailEntryProvider(
                  collectionId: collectionId,
                  entryId: entryIds[index],
                ),
              ),
            ),
            IconButton(
              onPressed: () => context.read<DetailCubit>().addToDoEntry(),
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
