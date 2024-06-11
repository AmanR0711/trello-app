import 'package:app/src/common/ui/trello_snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../common/ui/trello_form_field.dart';
import '../../dashboard/cubit/dashboard_cubit.dart';
import '../../dashboard/cubit/dashboard_state.dart';
import '../../dashboard/model/trello_board_bg_color.dart';

class CreateBoardForm extends StatefulWidget {
  const CreateBoardForm({super.key});

  @override
  State<CreateBoardForm> createState() => _CreateBoardFormState();
}

class _CreateBoardFormState extends State<CreateBoardForm> {
  late TrelloBoardBgColor? _color;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _color = TrelloBoardBgColor.grey;
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    final boardCubit = context.read<DashboardCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Create a new board",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: BlocListener<DashboardCubit, DashboardState>(
        bloc: boardCubit,
        listener: (context, state) {
          if (state is DashboardLoading) {
            showLoadingSnackBar(context, text: "Creating board...");
          } else if (state is DashboardLoaded) {
            showSuccessSnackBar(context, text: "Board created successfully!");
            context.go('/');
          } else if (state is DashboardError) {
            showErrorSnackBar(context, text: "An error occurred");
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Preview type widget
                  Text(
                    "Board background:",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[800]
                            : Colors.grey[200],
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
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
                      decoration: BoxDecoration(
                        color: _color != null ? _color!.color : Colors.grey,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // Form fields
                  TrelloFormField(
                    "Board name",
                    TextFormField(
                      validator: (v) => (v != null && v.isNotEmpty)
                          ? null
                          : "Enter a valid name",
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "Enter board name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // Description field
                  TrelloFormField(
                    "Board description",
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: "Enter board description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // TODO: Add scopes widget
                  const SizedBox(height: 20.0),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.check_box,
                        color: Colors.white,
                      ),
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all<Color>(
                          Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          boardCubit.createBoard(
                            _nameController.text,
                            _descriptionController.text,
                            _color!,
                          );
                        }
                      },
                      label: const Text(
                        "Create board",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<TrelloBoardBgColor?> _chooseBoardColor(BuildContext context) async {
    return await showDialog<TrelloBoardBgColor>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Choose a color"),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 250.0),
            child: StatefulBuilder(
              builder: (c, setState) => SingleChildScrollView(
                child: Column(
                  children: TrelloBoardBgColor.values
                      .map(
                        (bgColor) => RadioListTile<TrelloBoardBgColor>(
                          title: Text(
                            _getBgColorName(bgColor),
                            style: TextStyle(
                              color: Theme.of(c).brightness == Brightness.light
                                  ? Colors.grey.shade800
                                  : Colors.grey[200],
                            ),
                          ),
                          activeColor: bgColor.color,
                          value: bgColor,
                          groupValue: _color,
                          onChanged: (v) => setState(() => _color = v!),
                        ),
                      )
                      .toList(),
                ),
              ),
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

  String _getBgColorName(TrelloBoardBgColor bgColor) {
    String result = bgColor.name.replaceAllMapped(
      RegExp(r'_([a-z])'),
      (Match match) => ' ${match.group(1)!.toUpperCase()}',
    );
    return result[0].toUpperCase() + result.substring(1);
  }
}
