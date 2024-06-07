import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../common/ui/trello_message_widget.dart';
import 'cubit/dashboard_cubit.dart';
import 'cubit/dashboard_state.dart';
import 'ui/trello_board_card.dart';
import 'ui/view_profile_button.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<DashboardCubit>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "T.R.E.L.L.O",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Search button and profile icon
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          const ViewProfileButton(),
          const SizedBox(width: 8.0),
        ],
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        bloc: cubit,
        builder: (c, s) => _buildBody(cubit, c, s),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/board/new'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(
    DashboardCubit cubit,
    BuildContext context,
    DashboardState state,
  ) {
    if (state is DashboardLoading) {
      cubit.getBoards();
      return const Center(child: CircularProgressIndicator());
    }

    if (state is DashboardError) {
      return Center(
        child: TrelloMessageWidget(
          displayWidget: const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 64.0,
          ),
          title: "Oops! Something went wrong",
          message: state.message,
        ),
      );
    }

    if (state is DashboardLoaded) {
      if (state.boards.isEmpty) {
        return const Center(
          child: TrelloMessageWidget(
            displayWidget: Icon(
              Icons.check_circle_sharp,
              color: Colors.green,
              size: 64.0,
            ),
            title: "Everything Looks Lovely and Organized!",
            message: "You have no active boards. Great going!",
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              Text(
                "Your Boards",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (c, i) => TrelloBoardCard(state.boards[i]),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getCrossAxisCount(
                        MediaQuery.of(context).size.width,
                      ),
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }

    return Container();
  }

  int _getCrossAxisCount(double width) {
    if (width <= 480) {
      return 1;
    } else if (width > 480 && width <= 800) {
      return 2;
    } else if (width > 800 && width <= 1024) {
      return 3;
    } else {
      return 4;
    }
  }
}
