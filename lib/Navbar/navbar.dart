/*
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constants/color.dart';
import '../screens/Home/home.dart';
import '../screens/search/search.dart';
import '../services/API/call.dart';
import '../widgets/Drawer/drawer.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  bool isLoadingLogo = true;
  int _currentIndex = 0;
  Map<String, dynamic>? main;

  void _fetchLogo() async {
    try {
      var mainn = await YourColorJson().getMainData();
      setState(() {
        isLoadingLogo = false;
        main = mainn;
      });
    } catch (e) {
      setState(() {
        isLoadingLogo = false;
      });
    }
  }

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _fetchLogo();
  }

  @override
  Widget build(BuildContext context) {
    _screens = [
      const Home(apiKey: '9nf9EeJ4PflFeUFQIPKfJLy4'),
      const Search(),
      CustomDrawer(onTap: () {}),
      if (main != null && main!['UserAccounts'] == true)
        const Center(child: Text('البروفايل')),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // The IndexedStack keeps only the current screen active while retaining the state of others
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          // Positioned navigation bar at the bottom of the screen
          Positioned(
            bottom: 5,
            left: 5,
            right: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: GNav(
                    rippleColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    gap: 15,
                    activeColor: Colors.white,
                    iconSize: 24,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    // تقليل الـ padding الأفقي
                    tabBackgroundColor: const Color(0xffC62326),
                    color: Colors.grey.shade900,
                    tabs: [
                      GButton(
                        icon: Icons.home_outlined,
                        text: 'الرئيسيه',
                        textStyle: GoogleFonts.alexandria(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GButton(
                        icon: Icons.search,
                        text: 'البحث',
                        textStyle: GoogleFonts.alexandria(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GButton(
                        icon: Icons.category_outlined,
                        text: 'الأقسام',
                        textStyle: GoogleFonts.alexandria(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (main != null && main!['UserAccounts'] == true)
                        GButton(
                          icon: Icons.person_outline,
                          text: 'البروفايل',
                          textStyle: GoogleFonts.alexandria(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                    selectedIndex: _currentIndex,
                    onTabChange: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
