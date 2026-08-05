import 'package:flutter/material.dart';

import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/services/auth.dart';
import 'package:traintrack/widgets/custom_button.dart';

class LogoutDialog extends StatelessWidget {
  final String username;
  final AuthServices authServices;

  const LogoutDialog({
    super.key,
    required this.username,
    required this.authServices,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: 'Bye! ',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: kGreyColor,
              ),
            ),
            TextSpan(
              text: '$username 👋🏻\n',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: kGreyColor,
              ),
            ),
            const TextSpan(
              text: 'We wish to see you back real soon...',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: kGreyColor,
              ),
            ),
          ],
        ),
      ),
      content: const Text(
        'Are you sure you want to logout ?',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: kRedColor,
        ),
      ),
      actions: [
        CustomButton(
          buttonText: 'CANCEL',
          buttonColor1: kSubMainColor,
          buttonColor2: kMainColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CustomButton(
          buttonText: 'LOGOUT',
          buttonColor1: kRedColor,
          buttonColor2: kDarkRedColor,
          onPressed: () async {
            await authServices.signOut();
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
