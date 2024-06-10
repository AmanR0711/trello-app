import 'package:flutter/material.dart';

class TrelloMessageWidget extends StatelessWidget {
  final String title;
  final String message;
  final Widget? displayWidget;
  const TrelloMessageWidget({
    super.key,
    required this.title,
    required this.message,
    this.displayWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (displayWidget != null) displayWidget!,
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[800]
                      : Colors.grey[200],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Text(
            message,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[800]
                      : Colors.grey[200],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
