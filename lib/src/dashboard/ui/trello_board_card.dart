import 'package:flutter/material.dart';

class TrelloBoardCard extends StatefulWidget {
  const TrelloBoardCard({super.key});

  @override
  State<TrelloBoardCard> createState() => _TrelloBoardCardState();
}

class _TrelloBoardCardState extends State<TrelloBoardCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              color: Colors.blue,
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
                      "My Board",
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Colors.grey[800],
                          ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  "This is a board created by me to manage my tasks.",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.grey[800],
                      ),
                ),
                const SizedBox(height: 4.0),
                const Divider(indent: 50.0, endIndent: 50.0),
                const SizedBox(height: 4.0),
                Text(
                  "Created at: Jun 4, 2024",
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Colors.grey[500],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
