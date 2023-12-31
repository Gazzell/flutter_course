import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/2_application/pages/create_todo_entry_item/crete_todo_entry_item_page.dart';
import 'package:todo_app/2_application/pages/detail/bloc/detail_cubit.dart';
import 'package:todo_app/2_application/pages/detail/widgets/entry_item/entry_item.dart';
import 'package:todo_app/2_application/pages/home/cubit/navigation_to_do_cubit.dart';

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
    final detailCubit = context.read<DetailCubit>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: entryIds.length,
                itemBuilder: (context, index) => DetailEntryProvider(
                  key: Key('entry-${entryIds[index].value}'),
                  collectionId: collectionId,
                  entryId: entryIds[index],
                  onRemoved: () =>
                      detailCubit.removeToDoDetail(entryId: entryIds[index]),
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                if (Breakpoints.small.isActive(context)) {
                  final result = await context.pushNamed(
                    CreateToDoEntryItemPage.pageConfig.name,
                    pathParameters: {'collectionId': collectionId.value},
                  );
                  if (result == true) {
                    detailCubit.readToDoDetail();
                  }
                } else {
                  context.read<NavigationToDoCubit>().addToDoEntryItem();
                }
              },
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
