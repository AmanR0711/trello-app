import 'package:app/src/dashboard/model/trello_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../common/ui/trello_message_widget.dart';
import '../dashboard/cubit/dashboard_cubit.dart';
import 'ui/trello_board_list_view.dart';

class BoardScreen extends StatefulWidget {
  final String boardId;

  const BoardScreen(
    this.boardId, {
    super.key,
  });

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  late PageController _boardPageViewController;
  late GlobalKey<FormState> _addListKey;

  @override
  void initState() {
    super.initState();
    _addListKey = GlobalKey<FormState>();
    _boardPageViewController = PageController(
      initialPage: 0,
      keepPage: true,
      viewportFraction: 0.8,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _boardPageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardCubit = context.read<DashboardCubit>();
    return FutureBuilder(
      future: dashboardCubit.getBoard(widget.boardId),
      builder: (cc, snapshot) {
        print("snapshot: $snapshot");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          if (snapshot.data == null) {
            return const Center(
              child: Text('Board with this ID not found'),
            );
          } else {
            return Scaffold(
              backgroundColor: snapshot.data!.bgColor.color,
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                title: Text(
                  snapshot.data!.name,
                  style: const TextStyle(color: Colors.white),
                ),
                actions: [
                  IconButton(
                    onPressed: () =>
                        context.push('/board/${widget.boardId}/list/new'),
                    icon: const Icon(
                      Icons.add_box_outlined,
                      color: Colors.white,
                    ),
                    tooltip: "Add a new list",
                  ),
                  const SizedBox(width: 8.0),
                ],
              ),
              body: _buildBody(snapshot.data!),
            );
          }
        }
        return Container();
      },
    );
  }

  Widget _buildBody(TrelloBoard trelloBoard) {
    if (trelloBoard.lists.isEmpty) {
      return const Center(
        child: TrelloMessageWidget(
          title: "No Lists!",
          message: "Add a new list to get started",
          displayWidget: Icon(
            Icons.dashboard,
            color: Colors.white,
            size: 64,
          ),
        ),
      );
    }
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _boardPageViewController,
            itemCount: trelloBoard.lists.length,
            itemBuilder: (cc, index) {
              final list = trelloBoard.lists[index];
              return TrelloBoardListView(list);
            },
          ),
        ),
      ],
    );
  }
}
