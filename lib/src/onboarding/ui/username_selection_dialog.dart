import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/onboarding_cubit.dart';

class UsernameSelectionDialog extends StatefulWidget {
  const UsernameSelectionDialog({super.key});

  @override
  State<UsernameSelectionDialog> createState() =>
      _UsernameSelectionDialogState();
}

class _UsernameSelectionDialogState extends State<UsernameSelectionDialog> {
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<OnboardingCubit>(context);
    return AlertDialog(
      title: const Text("Choose a Username"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder(
            stream: cubit.usernameChannel.stream,
            builder: (context, snapshot) {
              print("Username chooser Snapshot: $snapshot");
              return TextFormField(
                controller: _usernameController,
                onChanged: (v) => cubit.verifyUsername(v),
                decoration: InputDecoration(
                  labelText: "Username",
                  hintText: "Enter a username",
                  error: _getErrorWidget(
                    _usernameController.value.text,
                    snapshot,
                  ),
                  helper: _getHelperWidget(
                    _usernameController.value.text,
                    snapshot,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade600,
                      width: 2.0,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Submit"),
        ),
      ],
    );
  }

  Widget? _getErrorWidget(String text, AsyncSnapshot snapshot) {
    if (snapshot.hasError) {
      return Text(
        snapshot.error.toString(),
        style: const TextStyle(
          color: Colors.red,
        ),
      );
    }
    return null;
  }

  Widget? _getHelperWidget(String text, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      return Text(
        snapshot.data.toString(),
        style: const TextStyle(
          color: Colors.green,
        ),
      );
    }
    return null;
  }
}
