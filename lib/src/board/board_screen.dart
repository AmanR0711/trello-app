import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(
        const Duration(seconds: 2),
      ),
      builder: (c, s)
      {
        if(s.connectionState == ConnectionState.waiting)
        {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Board ${widget.boardId}'),
            ),
            body: Center(
              child: Text('Board ${widget.boardId}'),
            ),
          );
        }
      },
    );
  }
}
