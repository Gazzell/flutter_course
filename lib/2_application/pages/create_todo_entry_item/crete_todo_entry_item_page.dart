import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:todo_app/2_application/pages/detail/detail_page.dart';
import 'package:todo_app/2_application/pages/home/cubit/navigation_to_do_cubit.dart';

class CreateToDoEntryItemPage extends StatefulWidget {
  final CollectionId collectionId;
  const CreateToDoEntryItemPage({super.key, required this.collectionId});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add entry'),
        leading: BackButton(
          onPressed: () {
            final isSecondBodyDisplayed =
                Breakpoints.mediumAndUp.isActive(context);
            if (isSecondBodyDisplayed) {
              context
                  .read<NavigationToDoCubit>()
                  .selectedToDoCollectionChanged(widget.collectionId);
              return;
            }
            if (context.canPop()) {
              context.pop();
            } else {
              context.goNamed(
                DetailPage.pageConfig.name,
                pathParameters: {
                  'collectionId': widget.collectionId.value,
                },
              );
            }
          },
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
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please, enter a description!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState?.validate();
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
