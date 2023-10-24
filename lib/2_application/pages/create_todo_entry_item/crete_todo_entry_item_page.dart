import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/1_domain/use_cases/create_todo_entry_item.dart';
import 'package:todo_app/2_application/core/form_value.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:todo_app/2_application/pages/create_todo_entry_item/cubit/create_to_do_entry_item_cubit.dart';
import 'package:todo_app/2_application/pages/detail/detail_page.dart';
import 'package:todo_app/2_application/pages/home/cubit/navigation_to_do_cubit.dart';

typedef CollectionUpdateCallback = Function;

class CreateToDoEntryItemPageProvider extends StatelessWidget {
  final CollectionId collectionId;
  final CollectionUpdateCallback updateCollectionCallback;

  const CreateToDoEntryItemPageProvider({
    super.key,
    required this.collectionId,
    required this.updateCollectionCallback,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateToDoEntryItemCubit(
        collectionId: collectionId,
        createToDoEntryItem: CreateToDoEntryItem(
          toDoRepository: RepositoryProvider.of<ToDoRepository>(context),
        ),
      ),
      child: CreateToDoEntryItemPage(
        updateCollectionCallback: updateCollectionCallback,
      ),
    );
  }
}

class CreateToDoEntryItemPage extends StatefulWidget {
  final Function updateCollectionCallback;
  const CreateToDoEntryItemPage(
      {super.key, required this.updateCollectionCallback});

  static const pageConfig = PageConfig(
    icon: Icons.add_rounded,
    name: 'add',
    child: Placeholder(),
  );

  @override
  State<CreateToDoEntryItemPage> createState() =>
      _CreateToDoEntryItemPageState();
}

class _CreateToDoEntryItemPageState extends State<CreateToDoEntryItemPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final createToDoEntryItemCubit = context.read<CreateToDoEntryItemCubit>();
    final collectionId = createToDoEntryItemCubit.collectionId;

    void tryGoBack() {
      final isSecondBodyDisplayed = Breakpoints.mediumAndUp.isActive(context);
      if (isSecondBodyDisplayed) {
        context
            .read<NavigationToDoCubit>()
            .selectedToDoCollectionChanged(collectionId);
        return;
      }

      widget.updateCollectionCallback();
      if (context.canPop()) {
        context.pop();
      } else {
        context.goNamed(
          DetailPage.pageConfig.name,
          pathParameters: {
            'collectionId': collectionId.value,
          },
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add entry'),
        leading: BackButton(
          onPressed: tryGoBack,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) {
                  createToDoEntryItemCubit.descriptionChanged(
                    description: value,
                  );
                },
                validator: (value) {
                  final currentValidationState = createToDoEntryItemCubit
                          .state.description?.validationStatus ??
                      ValidationStatus.pending;
                  switch (currentValidationState) {
                    case ValidationStatus.error:
                      return 'This field needs at least two characters to be valid';
                    case ValidationStatus.success:
                    case ValidationStatus.pending:
                      return null;
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final isValid = _formKey.currentState?.validate() ?? false;
                  if (isValid) {
                    await createToDoEntryItemCubit.submit();
                    tryGoBack();
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
