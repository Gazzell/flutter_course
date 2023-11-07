import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';
import 'package:todo_app/1_domain/use_cases/create_todo_collection.dart';
import 'package:todo_app/2_application/core/page_config.dart';
import 'package:todo_app/2_application/pages/create_todo_collection/cubit/create_to_do_collection_cubit.dart';
import 'package:todo_app/2_application/pages/create_todo_collection/widgets/color_picker.dart';

class CreateToDoCollectionPageProvider extends StatelessWidget {
  const CreateToDoCollectionPageProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateToDoCollectionCubit>(
      create: (context) => CreateToDoCollectionCubit(
        initialColor: 0xFFFFAB40,
        createToDoCollection: CreateToDoCollection(
          toDoRepository: RepositoryProvider.of<ToDoRepository>(context),
        ),
      ),
      child: const CreateToDoCollectionPage(),
    );
  }
}

class CreateToDoCollectionPage extends StatefulWidget {
  const CreateToDoCollectionPage({super.key});

  static const pageConfig = PageConfig(
    icon: Icons.add_task_rounded,
    name: 'create_todo_collection',
    child: CreateToDoCollectionPageProvider(),
  );

  @override
  State<CreateToDoCollectionPage> createState() =>
      _CreateToDoCollectionPageState();
}

class _CreateToDoCollectionPageState extends State<CreateToDoCollectionPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final createToDoCollectionCubit = context.read<CreateToDoCollectionCubit>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Title'),
                    onChanged: (value) =>
                        createToDoCollectionCubit.titleChanged(value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title!';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                BlocBuilder<CreateToDoCollectionCubit,
                    CreateToDoCollectionState>(
                  builder: (context, state) {
                    return ColorIndicator(
                      color: Color(createToDoCollectionCubit.state.color),
                      onSelect: () => colorPickerDialog(
                        color: Color(createToDoCollectionCubit.state.color),
                        context: context,
                        onColorChanged: (color) =>
                            createToDoCollectionCubit.colorChanged(color.value),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                final isValid = _formKey.currentState?.validate();
                if (isValid == true) {
                  context.read<CreateToDoCollectionCubit>().submit().then(
                        (value) => context.pop(true),
                      );
                }
              },
              child: const Text('Save Collection'),
            ),
          ],
        ),
      ),
    );
  }
}
