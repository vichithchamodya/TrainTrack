import 'package:flutter/material.dart';

import 'package:traintrack/constant/colors.dart';

class TrainingDetailsStatusItem extends StatelessWidget {
  final IconData statusIcon;
  final String statusText;

  const TrainingDetailsStatusItem({
    super.key,
    required this.statusIcon,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(statusIcon, color: kSubMainColor, size: 14),
        const SizedBox(width: 4),
        Text(
          statusText,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: kGreyColor,
          ),
        ),
      ],
    );
  }
}
