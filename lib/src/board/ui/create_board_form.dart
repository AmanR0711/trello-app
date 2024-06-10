import 'package:flutter/material.dart';

class CreateBoardForm extends StatefulWidget {
  const CreateBoardForm({super.key});

  @override
  State<CreateBoardForm> createState() => _CreateBoardFormState();
}

class _CreateBoardFormState extends State<CreateBoardForm> {
  late Color? _color;

  @override
  void initState() {
    super.initState();
    _color = Colors.greenAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a new board"),
      ),
      body: Column(
        children: [
          // Preview type widget
          InkWell(
            onTap: () async {
              final val = await _chooseBoardColor(context);
              setState(() {
                if (val != null) {
                  _color = val;
                }
              });
            },
            child: Container(
              height: 200.0,
              color: _color ?? Colors.greenAccent,
            ),
          ),
          const SizedBox(height: 20.0),
          // Form fields

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Board name",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          // Description field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Board description",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          // TODO: Add scopes widget
          const SizedBox(height: 20.0),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check_box, color: Colors.white,),
              style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              onPressed: () {},
              label: const Text(
                "Create board",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Color?> _chooseBoardColor(BuildContext context) async {
    return await showDialog<Color>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Choose a color"),
          content: StatefulBuilder(
            builder: (c, setState) => ListView(
              children: Colors.primaries
                  .map(
                    (color) => RadioListTile<Color>(
                      title: const Text("color name"),
                      activeColor: color,
                      value: color,
                      groupValue: _color,
                      onChanged: (v) => setState(() => _color = v!),
                    ),
                  )
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Select"),
            ),
          ],
        );
      },
    );
  }
}
