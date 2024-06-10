import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snackbar_plus/flutter_snackbar_plus.dart';
import 'package:go_router/go_router.dart';

import '../../common/ui/trello_confirm_dialog.dart';
import '../../common/ui/trello_form_field.dart';
import '../../dashboard/model/trello_board_bg_color.dart';
import '../cubit/board_cubit.dart';
import '../cubit/board_state.dart';

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
    final boardCubit = context.read<BoardCubit>();
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
      body: BlocListener<BoardCubit, BoardState>(
        bloc: boardCubit,
        listener: (context, state) {
          if (state is BoardLoading) {
            FlutterSnackBar.showTemplated(
              context,
              title: "Creating board",
              message: "Please wait...",
              style: FlutterSnackBarStyle(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                radius: BorderRadius.circular(6),
                backgroundColor: Colors.grey[700],
                shadow: BoxShadow(
                  color: Colors.black.withOpacity(0.55),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                  blurStyle: BlurStyle.normal,
                  spreadRadius: -10,
                ),
                leadingSpace: 22,
                trailingSpace: 12,
                padding: const EdgeInsets.all(20),
                titleStyle: const TextStyle(fontSize: 20, color: Colors.white),
                messageStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
                titleAlignment: TextAlign.start,
                messageAlignment: TextAlign.start,
                loadingBarColor: Colors.amber,
                loadingBarRailColor: Colors.amber.withOpacity(0.4),
              ),
            );
          } else if (state is BoardSubmittingSuccess) {
            FlutterSnackBar.showTemplated(
              context,
              title: state.success,
              leading: const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
              ),
              style: FlutterSnackBarStyle(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                radius: BorderRadius.circular(6),
                backgroundColor: Colors.green[400],
                shadow: BoxShadow(
                  color: Colors.black.withOpacity(0.55),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                  blurStyle: BlurStyle.normal,
                  spreadRadius: -10,
                ),
                leadingSpace: 22,
                trailingSpace: 12,
                padding: const EdgeInsets.all(20),
                titleStyle: const TextStyle(fontSize: 20, color: Colors.white),
                messageStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
                titleAlignment: TextAlign.start,
                messageAlignment: TextAlign.start,
              ),
            );
            context.pop(true);
          } else if (state is BoardSubmittingFailed) {
            FlutterSnackBar.showTemplated(
              context,
              title: "An Error occurred",
              message: "Please try again",
              leading: const Icon(
                Icons.error_outline_outlined,
                color: Colors.white,
              ),
              style: FlutterSnackBarStyle(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                radius: BorderRadius.circular(6),
                backgroundColor: Colors.red[400],
                shadow: BoxShadow(
                  color: Colors.black.withOpacity(0.55),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                  blurStyle: BlurStyle.normal,
                  spreadRadius: -10,
                ),
                leadingSpace: 22,
                trailingSpace: 12,
                padding: const EdgeInsets.all(20),
                titleStyle: const TextStyle(fontSize: 20, color: Colors.white),
                messageStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
                titleAlignment: TextAlign.start,
                messageAlignment: TextAlign.start,
                loadingBarColor: Colors.amber,
                loadingBarRailColor: Colors.amber.withOpacity(0.4),
              ),
            );
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
                              color: Colors.grey[200],
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
