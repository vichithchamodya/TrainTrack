import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:traintrack/services/auth.dart';
import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/data/avatar_data.dart';
import 'package:traintrack/models/user_model.dart';
import 'package:traintrack/services/user_service.dart';
import 'package:traintrack/widgets/logout_dialog.dart';
import 'package:traintrack/widgets/profile_status_card.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // create a object from auth service
  final AuthServices _auth = AuthServices();
  final UserService _userService = UserService();
  final ImagePicker _picker = ImagePicker();
  final avatarImages = AvatarData.avatarList;
  bool _isUploadingPhoto = false;

  Future<void> _pickAndUploadPhoto(String uid, ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
      );
      if (picked == null) return;

      setState(() => _isUploadingPhoto = true);
      await _userService.updateProfilePicture(uid, File(picked.path));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Couldn't update photo: $e")));
      }
    } finally {
      if (mounted) setState(() => _isUploadingPhoto = false);
    }
  }

  Future<void> _selectAvatar(String uid, String assetPath) async {
    try {
      setState(() => _isUploadingPhoto = true);
      await _userService.setAvatarPicture(uid, assetPath);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Couldn't set avatar: $e")));
      }
    } finally {
      if (mounted) setState(() => _isUploadingPhoto = false);
    }
  }

  Future<void> _removePhoto(String uid) async {
    try {
      setState(() => _isUploadingPhoto = true);
      await _userService.removeProfilePicture(uid);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Couldn't remove photo: $e")));
      }
    } finally {
      if (mounted) setState(() => _isUploadingPhoto = false);
    }
  }

  void _showImagePickerBottomSheet(String uid) {
    const menuOptions = [
      (
        Icons.camera_alt,
        kSubMainColor,
        "Take Photo",
        "Use your camera",
        ImageSource.camera,
      ),
      (
        Icons.photo_library,
        kGreenColor,
        "Choose from Gallery",
        "Pick an existing photo",
        ImageSource.gallery,
      ),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // hanger
                Container(
                  height: 5,
                  width: 48,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade300,
                  ),
                ),
                const Text(
                  "Select Profile Picture",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),

                // avatar grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                  ),
                  itemCount: avatarImages.length,
                  itemBuilder: (context, index) {
                    return Animate(
                      effects: [
                        SlideEffect(
                          begin: const Offset(0, 0.6),
                          duration: 300.ms,
                          curve: Curves.easeOutBack,
                        ),
                        FadeEffect(duration: 200.ms),
                      ],
                      delay: (index * 50).ms,
                      child: _buildAvatarOption(uid, avatarImages[index]),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // camera / gallery / remove options
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: menuOptions.length,
                  itemBuilder: (context, index) {
                    final (icon, color, title, subtitle, source) =
                        menuOptions[index];
                    return Animate(
                      effects: [
                        SlideEffect(
                          begin: const Offset(0, 1),
                          duration: 400.ms,
                          curve: Curves.easeOutBack,
                        ),
                        FadeEffect(duration: 200.ms),
                      ],
                      delay: (index * 100).ms,
                      child: ListTile(
                        dense: true,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withAlpha((0.1 * 255).round()),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(icon, color: color),
                        ),
                        title: Text(
                          title,
                          style: const TextStyle(fontSize: 14),
                        ),
                        subtitle: Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: kGreyColor,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onTap: () {
                          Navigator.pop(sheetContext);
                          _pickAndUploadPhoto(uid, source);
                        },
                      ),
                    );
                  },
                ),

                // remove option, styled the same way but separated
                Animate(
                  effects: [
                    SlideEffect(
                      begin: const Offset(0, 1),
                      duration: 400.ms,
                      curve: Curves.easeOutBack,
                    ),
                    FadeEffect(duration: 200.ms),
                  ],
                  delay: (menuOptions.length * 100).ms,
                  child: ListTile(
                    dense: true,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: kRedColor.withAlpha((0.1 * 255).round()),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete, color: kRedColor),
                    ),
                    title: const Text(
                      "Remove Photo",
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: const Text(
                      "Use the default icon instead",
                      style: TextStyle(fontSize: 12, color: kGreyColor),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _removePhoto(uid);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatarOption(String uid, String assetPath) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _selectAvatar(uid, assetPath);
      },
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: kShadowColor,
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Image(image: AssetImage(assetPath), fit: BoxFit.cover),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    final displayName = user?.username.trim().isNotEmpty == true
        ? user!.username
        : "User";
    final email = user?.email.trim().isNotEmpty == true ? user!.email : "";
    final photoUrl = user?.photoUrl ?? "";
    final isAssetAvatar = photoUrl.startsWith("assets/");
    final ImageProvider? avatarImage = photoUrl.isEmpty
        ? null
        : isAssetAvatar
        ? AssetImage(photoUrl)
        : NetworkImage(photoUrl) as ImageProvider;
    final progress = user?.trainingProgress.values.toList() ?? const [];
    final completedCount = progress.where((item) => item.completed).length;
    final trainedMinutes = progress.fold<int>(
      0,
      (total, item) => total + item.minutesSpent,
    );

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
                    children:
                        [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: kGreyColor,
                                backgroundImage: avatarImage,
                                child: avatarImage == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 80,
                                        color: kWhiteColor,
                                      )
                                    : null,
                              ),
                              if (_isUploadingPhoto)
                                const Positioned.fill(
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: kWhiteColor,
                                    ),
                                  ),
                                ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () =>
                                      _showImagePickerBottomSheet(user!.uid),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: kSubMainColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: kWhiteColor,
                                        width: 1,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: kShadowColor,
                                          spreadRadius: 3,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 18,
                                      color: kWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ]
                            .animate(interval: 200.ms)
                            .scale(duration: 400.ms, curve: Curves.easeOutBack),
                  ),
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
                    email.isNotEmpty ? email : "@user",
                    style: const TextStyle(fontSize: 14, color: kGreyColor),
                  ),
                ],
              ),
            ),
          ),

          // scrollable content
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ProfileStatusCard(
                        statusIcon: Icons.school,
                        statusValue: progress.length.toString(),
                        statusTitle: "Enrolled",
                      ),
                      ProfileStatusCard(
                        statusIcon: Icons.access_time,
                        statusValue:
                            "${(trainedMinutes / 60).toStringAsFixed(1)} H",
                        statusTitle: "Trained",
                      ),
                      ProfileStatusCard(
                        statusIcon: Icons.star,
                        statusValue: completedCount.toString(),
                        statusTitle: "Achieved",
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  if (progress.isNotEmpty)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? kWhiteColor
                            : kBlackColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "My Trainings",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: kGreyColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...progress.map(
                            (item) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                item.completed
                                    ? Icons.check_circle
                                    : Icons.play_circle,
                                color: item.completed
                                    ? kGreenColor
                                    : kSubMainColor,
                              ),
                              title: Text(
                                item.trainingName.isEmpty
                                    ? item.trainingId
                                    : item.trainingName,
                              ),
                              subtitle: Text(
                                item.completed
                                    ? "Completed"
                                    : "Current step ${item.currentStep + 1} of ${item.totalSteps}",
                              ),
                            ),
                          ),
                        ],
                      ),
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
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [kSubMainColor, kMainColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
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
