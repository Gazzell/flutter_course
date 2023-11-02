import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/2_application/pages/create_todo_collection/create_todo_collection_page.dart';
import 'package:todo_app/2_application/pages/detail/detail_page.dart';
import 'package:todo_app/2_application/pages/home/cubit/navigation_to_do_cubit.dart';

class OverviewLoaded extends StatelessWidget {
  final List<ToDoCollection> collections;

  const OverviewLoaded({super.key, required this.collections});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final shouldDisplayAddItemButton = Breakpoints.small.isActive(context);
    return Stack(
      children: [
        ListView.builder(
          itemCount: collections.length,
          itemBuilder: (context, index) {
            final item = collections[index];
            return BlocBuilder<NavigationToDoCubit, NavigationToDoCubitState>(
              buildWhen: (previous, current) =>
                  previous.selectedToDoCollectionId !=
                  current.selectedToDoCollectionId,
              builder: (context, state) {
                return ListTile(
                  tileColor: colorScheme.surface,
                  selectedTileColor: colorScheme.surfaceVariant,
                  iconColor: item.color.color,
                  selectedColor: item.color.color,
                  selected: state.selectedToDoCollectionId == item.id,
                  onTap: () {
                    if (Breakpoints.small.isActive(context)) {
                      context.pushNamed(
                        DetailPage.pageConfig.name,
                        pathParameters: {'collectionId': item.id.value},
                      );
                    }
                    context
                        .read<NavigationToDoCubit>()
                        .selectedToDoCollectionChanged(item.id);
                  },
                  leading: const Icon(Icons.circle),
                  title: Text(item.title),
                );
              },
            );
          },
        ),
        if (shouldDisplayAddItemButton)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                key: const Key('create-todo-collection'),
                heroTag: 'create-todo-collection',
                onPressed: () =>
                    context.pushNamed(CreateToDoCollectionPage.pageConfig.name),
                child: Icon(CreateToDoCollectionPage.pageConfig.icon),
              ),
            ),
          )
      ],
    );
  }
}
