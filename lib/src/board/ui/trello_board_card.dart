import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../common/ui/trello_confirm_dialog.dart';
import '../../common/ui/trello_snackbars.dart';
import '../../dashboard/cubit/dashboard_cubit.dart';
import '../../dashboard/cubit/dashboard_state.dart';
import '../../dashboard/model/trello_board.dart';

class TrelloBoardCard extends StatefulWidget {
  final bool isCreator;
  final TrelloBoard board;

  const TrelloBoardCard(this.board, this.isCreator, {super.key});

  @override
  State<TrelloBoardCard> createState() => _TrelloBoardCardState();
}

class _TrelloBoardCardState extends State<TrelloBoardCard> {
  @override
  Widget build(BuildContext context) {
    final boardCubit = context.read<DashboardCubit>();
    return BlocListener<DashboardCubit, DashboardState>(
      bloc: boardCubit,
      listener: (con, state) {
        if (state is DashboardLoading) {
          showLoadingSnackBar(context, text: "Deleting board...");
        } else if (state is DashboardLoaded) {
          showSuccessSnackBar(context, text: "Board deleted successfully");
        } else if (state is DashboardError) {
          showErrorSnackBar(context, text: "Failed to delete board");
        }
      },
      child: InkWell(
        onTap: () => context.push('/board/${widget.board.id}'),
        child: Card(
          shadowColor: Colors.black,
          elevation: 12.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                  color: widget.board.bgColor.color,
                ),
                height: 150.0,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.board.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                fontWeight: FontWeight.w800,
                                color: Colors.grey[800],
                              ),
                        ),
                        PopupMenuButton(
                          icon: Icon(Icons.more_vert, color: Colors.grey[800]),
                          enabled: widget.isCreator,
                          itemBuilder: (con) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: const Text(
                                'Edit',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onTap: () {},
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () async {
                                final res = await showDialog<bool>(
                                  context: con,
                                  builder: (cc) => TrelloConfirmDialog(
                                    message: "Delete '${widget.board.name}'?",
                                  ),
                                );
                                if (res != null && res) {
                                  boardCubit.deleteBoard(widget.board.id);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      widget.board.description,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.grey[800],
                          ),
                    ),
                    const SizedBox(height: 4.0),
                    const Divider(indent: 50.0, endIndent: 50.0),
                    const SizedBox(height: 4.0),
                    Text(
                      "Created at: ${DateFormat.yMMMMEEEEd().format(widget.board.createdAt)}",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Colors.grey[500],
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
