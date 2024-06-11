import 'package:flutter/material.dart';

import '../../common/ui/trello_message_widget.dart';
import '../model/trello_board_list.dart';
import '../model/trello_board_task.dart';

class TrelloBoardListView extends StatelessWidget {
  final TrelloBoardList list;

  const TrelloBoardListView(this.list, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              list.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: list.description.isEmpty ? null : Text(list.description),
          ),
          if (list.tasks.isEmpty)
            const Center(
              child: TrelloMessageWidget(
                title: "No Tasks",
                message: "Add a task",
                displayWidget: Icon(
                  Icons.edit,
                  color: Colors.blue,
                  size: 32,
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: list.tasks.length,
                itemBuilder: (cc, index) {
                  final task = list.tasks[index];
                  return ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
