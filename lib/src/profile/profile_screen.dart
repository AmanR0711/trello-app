import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../common/ui/trello_message_widget.dart';
import '../onboarding/bloc/onboarding_cubit.dart';
import '../onboarding/model/theme_type.dart';
import '../onboarding/model/trello_user.dart';
import '../onboarding/ui/username_selection_dialog.dart';
import 'cubit/profile_cubit.dart';
import 'cubit/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    final onboardingCubit = context.read<OnboardingCubit>();
    return BlocBuilder<ProfileCubit, ProfileState>(
      bloc: cubit,
      builder: (c, s) {
        if (s is ProfileLoading) {
          cubit.getProfile();
          return const Center(child: CircularProgressIndicator());
        } else if (s is ProfileLoaded) {
          return _buildBody(cubit, onboardingCubit, c, s.user);
        } else if (s is ProfileError) {
          return TrelloMessageWidget(
            title: "An Error Occurred",
            message: s.message,
            displayWidget: const Icon(
              Icons.warning_amber_outlined,
              color: Colors.amber,
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildBody(
    ProfileCubit cubit,
    OnboardingCubit onboardingCubit,
    BuildContext context,
    TrelloUser user,
  ) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(12.0),
      children: [
        Center(
          child: InkWell(
            onTap: () async {
              final file = await _getFile();
              if (file != null) {
                cubit.updateProfile(avatar: file);
              }
            },
            child: CircleAvatar(
              radius: 52.0,
              backgroundColor: const Color.fromARGB(255, 199, 193, 177),
              child: CircleAvatar(
                radius: 48.0,
                backgroundImage: NetworkImage(user.avatarUrl),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.username,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (c) => BlocProvider.value(
                  value: onboardingCubit,
                  child: const UsernameSelectionDialog(),
                ),
              ),
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
        Text(user.email, textAlign: TextAlign.center),
        const SizedBox(height: 16.0),
        Text(
          'Joined ${DateFormat.yMMMMEEEEd().format(user.createdAt!)}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Dark Mode: ",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Switch(
              value: user.theme == ThemeType.dark,
              trackColor: const WidgetStatePropertyAll(Colors.amber),
              onChanged: (value) {
                cubit.updateProfile(
                  theme: value ? ThemeType.dark : ThemeType.light,
                );
                context.go('/');
              },
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          width: 200,
          child: ElevatedButton(
            onPressed: () {
              onboardingCubit.signOut();
              context.push('/');
            },
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              foregroundColor: const WidgetStatePropertyAll(Colors.white),
              textStyle: const WidgetStatePropertyAll(
                TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: const WidgetStatePropertyAll(Colors.red),
            ),
            child: const Text('Logout'),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Future<List<int>?> _getFile() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg'],
      allowMultiple: false,
      dialogTitle: "Choose avatar",
    );
    final ans = res?.files.first.bytes?.toList();
    print("_getFile() ->" + ans.toString());
    return ans;
  }
}
