import 'package:flutter/material.dart';

import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/models/user_model.dart';
import 'package:traintrack/services/auth.dart';

class AccountRestrictedScreen extends StatelessWidget {
  final UserModel user;

  const AccountRestrictedScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isBanned = user.isBanned;
    final timeout = user.timeoutUntil;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isBanned ? Icons.block : Icons.timer_off_outlined,
                size: 72,
                color: kRedColor,
              ),
              const SizedBox(height: 20),
              Text(
                isBanned ? "Account banned" : "Account temporarily restricted",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isBanned
                    ? (user.bannedReason.isEmpty
                          ? "Your account cannot access TrainTrack."
                          : "Reason: ${user.bannedReason}")
                    : "Access will return after ${_formatDate(timeout!)}.",
                textAlign: TextAlign.center,
                style: const TextStyle(color: kGreyColor),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: () => AuthServices().signOut(),
                icon: const Icon(Icons.logout),
                label: const Text("SIGN OUT"),
                style: FilledButton.styleFrom(
                  backgroundColor: kSubMainColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    return "${local.day}/${local.month}/${local.year} ${local.hour}:${local.minute.toString().padLeft(2, '0')}";
  }
}
