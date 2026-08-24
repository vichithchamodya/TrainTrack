import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:traintrack/widgets/bitzy.dart';
import 'package:traintrack/constant/colors.dart';
import 'package:traintrack/models/user_model.dart';

// dashboard screens
import 'package:traintrack/pages/dashboard/tools.dart';
import 'package:traintrack/pages/dashboard/profile.dart';
import 'package:traintrack/pages/dashboard/explore.dart';
import 'package:traintrack/pages/dashboard/watchlist.dart';
import 'package:traintrack/pages/dashboard/my_trainings.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  double rotationAngle = 0; // rotation angle for the Z-axis
  bool isDrawerOpen = false;

  // date and time formatter
  final DateFormat formatter = DateFormat("EEEE, MMMM, dd");

  // function to determine greeting message based on time
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning..!";
    } else if (hour < 18) {
      return "Good Afternoon..!";
    } else {
      return "Good Evening..!";
    }
  }

  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void toggleDrawer() {
    setState(() {
      if (isDrawerOpen) {
        xOffset = 0;
        yOffset = 0;
        scaleFactor = 1;
        rotationAngle = 0;
        isDrawerOpen = false;
      } else {
        // open drawer with rotation
        xOffset = MediaQuery.of(context).size.width * 0.5;
        yOffset = MediaQuery.of(context).size.height * 0.15;
        // slight rotation in radians (approx. -2.8 degrees)
        rotationAngle = 0.08;
        scaleFactor = 0.80;
        isDrawerOpen = true;
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    final username = user?.username.trim().isNotEmpty == true
        ? user!.username
        : "User";
    String greeting = getGreeting();

    return AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scaleByDouble(scaleFactor, scaleFactor, scaleFactor, 1)
        ..rotateZ(rotationAngle),
      duration: const Duration(milliseconds: 300),

      child: ClipRRect(
        borderRadius: isDrawerOpen
            ? BorderRadius.circular(30)
            : BorderRadius.zero,
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: Colors.blueAccent,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello $username,",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: kGreyColor,
                  ),
                ),
                Text(
                  greeting,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    //color: kBlackColor,
                  ),
                ),
              ],
            ),
            leading: IconButton(
              onPressed: toggleDrawer,
              icon: Icon(
                isDrawerOpen ? Icons.arrow_back_ios : Icons.menu,
                //color: kBlackColor,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: MySearchDelegate());
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {},
              ),
              Builder(
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      child: Image.asset(
                        "assets/gifs/onboarding_3.gif",
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                      onTap: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          endDrawer: Drawer(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(26)),
            ),
            clipBehavior: Clip.antiAlias,
            width: MediaQuery.of(context).size.width * 0.8,
            child: const Bitzy(),
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              Explore(),
              Watchlist(),
              Tools(),
              MyTrainings(),
              Profile(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedItemColor: kSubMainColor,
            unselectedItemColor: kGreyColor,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            onTap: (index) {
              _pageController.animateToPage(
                index,
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 300),
              );
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: "Explore",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmarks),
                label: "Watchlist",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.perm_data_setting_rounded),
                label: "Tools",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: "My Trainings",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// search bar delegate
class MySearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(child: Text(query, style: const TextStyle(fontSize: 14)));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = [
      "Leadership",
      "Health",
      "Diversity",
      "Inclusion",
      "Project Management",
      "Professional Development",
    ];
    suggestions = suggestions
        .where((element) => element.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return SizedBox(
            height: 45,
            child: Text(
              suggestions[index],
              style: const TextStyle(fontSize: 14),
            ),
          );
        },
      ),
    );
  }
}
