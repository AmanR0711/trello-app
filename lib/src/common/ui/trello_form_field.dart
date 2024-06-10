import 'package:flutter/material.dart';

class TrelloFormField extends StatelessWidget {
  final String label;
  final Widget child;

  const TrelloFormField(
    this.label,
    this.child, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey[800]
                    : Colors.grey[200],
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8.0),
        child,
      ],
    );
  }
}
