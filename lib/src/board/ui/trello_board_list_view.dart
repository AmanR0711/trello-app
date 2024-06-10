import 'package:flutter/material.dart';

import '../model/trello_board_task.dart';

class TrelloBoardListView extends StatelessWidget {
  final List<TrelloBoardTask> tasks;

  const TrelloBoardListView(
    this.tasks, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: tasks.length,
      itemBuilder: (cc, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
        );
      },
    );
  }
}
