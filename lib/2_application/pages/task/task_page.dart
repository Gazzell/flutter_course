import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/2_application/core/page_config.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({
    super.key,
  });

  static const pageConfig = PageConfig(
    icon: Icons.task_rounded,
    name: 'task',
    child: TaskPage(),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightGreen,
      child: Column(
        children: [
          const Text('Task'),
          ElevatedButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home/start');
              }
            },
            child: const Text('Go to Start'),
          ),
          TextButton(
            onPressed: () => context.replace('/home/settings'),
            child: const Text('Go to settings'),
          ),
        ],
      ),
    );
  }
}
