import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:traintrack/services/auth.dart';
import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/models/user_model.dart';
import 'package:traintrack/widgets/logout_dialog.dart';
import 'package:traintrack/pages/side_menu_screens/settings_screen.dart';

class SideMenu extends StatelessWidget {
  SideMenu({super.key});

  // create a object from auth service
  final AuthServices _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    final username = user?.username.trim().isNotEmpty == true
        ? user!.username
        : 'User';

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kSubMainColor, kBlackColor],
          begin: Alignment.topLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildHeader(),
            _buildMenuItems(context),
            _buildFooter(context, username),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: kShadowColor,
          ),
          child: Image.asset(
            "assets/images/logo.png",
            width: 40,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          "Train Track",
          style: TextStyle(
            fontFamily: "Orbitron",
            color: kWhiteColor,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        "icon": Icons.settings_outlined,
        "text": "Settings",
        "page": const Settings(),
      },
      {
        "icon": Icons.download_done,
        "text": "Downloads",
        "page": const Settings(),
      },
      {
        "icon": Icons.chat_bubble_outline,
        "text": "Messages",
        "page": const Settings(),
      },
      {
        "icon": Icons.bookmark_border,
        "text": "Watchlist",
        "page": const Settings(),
      },
      {
        "icon": Icons.favorite_border,
        "text": "My Trainings",
        "page": const Settings(),
      },
      {
        "icon": Icons.lightbulb_outline,
        "text": "Hint",
        "page": const Settings(),
      },
      {"icon": Icons.star_border, "text": "Rate Us", "page": const Settings()},
    ];

    return Column(
      children: menuItems.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: _buildMenuItem(
            icon: item["icon"],
            text: item["text"],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => item["page"]),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      splashColor: const Color(0xFF448AFF),
      highlightColor: Colors.transparent,
      child: Row(
        children: [
          Icon(icon, color: kWhiteColor),
          const SizedBox(width: 20),
          Text(text, style: const TextStyle(color: kWhiteColor)),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, String username) {
    return GestureDetector(
      onTap: () => _showDialog(context, username),
      child: const Row(
        children: [
          Icon(Icons.logout, color: kGreyColor),
          SizedBox(width: 10),
          Text("Log out", style: TextStyle(color: kRedColor)),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, String username) {
    showDialog(
      context: context,
      barrierColor: const Color(0xC5000000),
      builder: (BuildContext context) {
        return LogoutDialog(username: username, authServices: _auth);
      },
    );
  }
}
