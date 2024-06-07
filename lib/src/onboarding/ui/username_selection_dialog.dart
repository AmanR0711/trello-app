import 'dart:async';

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
  late StreamController<bool> _usernameStreamController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _usernameStreamController = StreamController<bool>.broadcast();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<OnboardingCubit>(context);
    return AlertDialog(
      title: const Text("Choose a Username"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<Map<String, dynamic>>(
            stream: cubit.usernameStreamController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData) {
                Future.delayed(
                  const Duration(milliseconds: 1500),
                  () => cubit.tryConnectingToServer(),
                );
              }
              print("Username chooser Snapshot: $snapshot");
              return Form(
                key: _formKey,
                child: TextFormField(
                  enabled: snapshot.connectionState != ConnectionState.waiting,
                  controller: _usernameController,
                  onChanged: (v) {
                    print("typing: $v ($snapshot)");
                    cubit.verifyUsername(v);
                  },
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
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final user = await cubit.getSession();
              if (user != null) {
                cubit.updateProfile(
                  user,
                  username: _usernameController.value.text,
                );
                Future.delayed(const Duration(milliseconds: 1500), () {
                  Navigator.of(context).pop(true);
                });
              }
            }
          },
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
    if (snapshot.connectionState == ConnectionState.waiting &&
        !snapshot.hasData) {
      return const Text(
        "Connecting to server...",
        style: TextStyle(color: Colors.blueGrey),
      );
    }
    if (snapshot.hasData) {
      return Text(
        snapshot.data['message'].toString(),
        style: const TextStyle(
          color: Colors.green,
        ),
      );
    }
    return null;
  }
}
