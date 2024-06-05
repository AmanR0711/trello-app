import 'dart:math';

import 'package:flutter/material.dart';

import '../common/ui/trello_message_widget.dart';
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
          ]),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    /**
     * const Center(
        child: TrelloMessageWidget(
          displayWidget: Icon(
            Icons.check_circle_sharp,
            color: Colors.green,
            size: 64.0,
          ),
          title: "Everything Looks Lovely and Organized!",
          message: "You have no active boards. Great going!",
        ),
      ),
     */
    final width = MediaQuery.of(context).size.width;
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
                itemBuilder: (c, i) => const TrelloBoardCard(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: min((width / 300).toInt(), 4) <= 0
                      ? 1
                      : min((width / 300).toInt(), 4),
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
