import 'package:flutter/material.dart';

class ViewProfileButton extends StatelessWidget {
  const ViewProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      radius: 18.0,
      child: InkWell(
        onTap: (){},
        child: const CircleAvatar(
          radius: 16.0,
          backgroundColor: Colors.orange,
          child: Text(
            "A",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}