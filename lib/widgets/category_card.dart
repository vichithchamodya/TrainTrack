import 'package:flutter/material.dart';
import 'package:traintrack/constant/colors.dart';

class CategoryCard extends StatelessWidget {
  final IconData categoryIcon;
  final String categoryName;
  final VoidCallback categoryOnTap;

  const CategoryCard({
    super.key,
    required this.categoryIcon,
    required this.categoryName,
    required this.categoryOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: categoryOnTap,
        style: ElevatedButton.styleFrom(alignment: Alignment.centerLeft),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(categoryIcon, color: kSubMainColor),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                categoryName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: kGreyColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
