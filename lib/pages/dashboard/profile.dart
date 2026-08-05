import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/models/user_model.dart';
import 'package:traintrack/services/auth.dart';
import 'package:traintrack/widgets/logout_dialog.dart';
import 'package:traintrack/widgets/profile_status_card.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  // create a object from auth service
  final AuthServices _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    final displayName = user?.username.trim().isNotEmpty == true
        ? user!.username
        : "User";
    final email = user?.email.trim().isNotEmpty == true ? user!.email : "";

    return Scaffold(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // profile picture
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: kGreyColor,
                        child: Icon(Icons.person, size: 80, color: kWhiteColor),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.camera_alt, color: kWhiteColor),
                        color: kSubMainColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // username & eamil
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email.isNotEmpty ? email : '@user',
                    style: const TextStyle(fontSize: 14, color: kGreyColor),
                  ),
                ],
              ),
            ),
          ),

          // scrollable content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // hanger
                    Container(
                      height: 6,
                      width: 60,
                      margin: const EdgeInsets.only(top: 8, bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade300,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // profile status cards
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ProfileStatusCard(
                          statusIcon: Icons.school,
                          statusValue: "25",
                          statusTitle: "Enrolled",
                        ),
                        ProfileStatusCard(
                          statusIcon: Icons.access_time,
                          statusValue: "120 H",
                          statusTitle: "Trained",
                        ),
                        ProfileStatusCard(
                          statusIcon: Icons.star,
                          statusValue: "12",
                          statusTitle: "Achievements",
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // settings & actions section
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? kWhiteColor
                            : kBlackColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                ? Colors.grey.shade200
                                : kShadowColor,
                            blurRadius: 10,
                            spreadRadius: 5,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Account Settings",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: kGreyColor,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Column(
                            children: [
                              _buildSettingsTile(
                                context,
                                title: "Edit Profile",
                                icon: Icons.edit,
                                onTap: () {},
                              ),
                              _buildSettingsTile(
                                context,
                                title: "Privacy Settings",
                                icon: Icons.lock,
                                iconColor: kGreyColor,
                                onTap: () {},
                              ),
                              _buildSettingsTile(
                                context,
                                title: "Notifications",
                                icon: Icons.notifications,
                                iconColor: kOrangeColor,
                                onTap: () {},
                              ),
                              _buildSettingsTile(
                                context,
                                title: "Payment Methods",
                                icon: Icons.payment,
                                iconColor: kGreenColor,
                                onTap: () {},
                              ),
                              _buildSettingsTile(
                                context,
                                title: "Logout",
                                icon: Icons.logout,
                                iconColor: kRedColor,
                                onTap: () => _showDialog(context, displayName),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // motivational section
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: kSubMainColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "“Keep up the great work! You're doing amazing!”",
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: kWhiteColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kWhiteColor,
                              foregroundColor: kSubMainColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text("View Achievements"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // settings tile
  Widget _buildSettingsTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    Color iconColor = kSubMainColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.only(right: 10),
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: kGreyColor,
      ),
      onTap: onTap,
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
