import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants/color.dart';
import '../../Model/Categories/categoris.dart';
import '../../Model/main/main.dart';
import '../../services/API/call.dart';

class HomeProvider with ChangeNotifier {
  final String apiKey;
  late final FetchMain fetchMainDataModel;

  HomeProvider({required this.apiKey, required this.fetchMainDataModel});

  int backPressCount = 0;
  final PageController pageController = PageController(viewportFraction: 0.47);
  String? error;
  bool isInitialLoading = true;
  bool hasMorePosts = true;
  int currentOffset = 0;
  int currentPage = 0;
  var logger = Logger();
  bool isButtonVisible = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();
  final ScrollController mainScrollController = ScrollController();
  late Future<Map<String, dynamic>> widgets;
  bool isAdLoaded = false;
  bool isLoading = true;
  bool floatingbutton = false;
  bool dateAppBar = false;
  bool stickyAppBar = false;
  bool showAutoSlide = false;
  bool isLoadingLogo = true;
  bool showBoxShadow = false;
  bool isInternetConnected = true;
  List<Categoryy> categories = [];
  List<Categoryy> categories2 = [];
  late TabController tabController;
  int scrollFetchCounter = 0;
  late Future<Map<String, dynamic>> futureCombinedData;
  List<Map<String, dynamic>> posts = [];
  PageController pageControllerDetails = PageController(viewportFraction: 0.5);

  @override
  void dispose() {
    scrollController.dispose();
    mainScrollController.dispose();
    tabController.dispose();
    pageController.dispose();
    super.dispose();
  }

  Future<void> fetchMainData() async {
    try {
      final response = await http.post(
        Uri.parse('${YourColorJson().baseUrl}/wp-json/app/v1/main'),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        fetchMainDataModel = FetchMain.fromJson(jsonResponse);
        isLoading = false;
        notifyListeners();
      } else {
        error = 'Failed to load data';
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      error = 'Failed to load data';
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> fetchCombinedData() async {
    try {
      final results = await Future.wait([YourColorJson().getHomeData()]);
      return {'userData': results[0]};
    } catch (e) {
      throw Exception('Failed to fetch combined data: $e');
    }
  }

  void openLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void scrollToTop() {
    if (mainScrollController.hasClients) {
      mainScrollController.animateTo(
        0,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<bool> showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                backgroundColor: Colors.white,
                title: Column(
                  children: [
                    Lottie.asset(
                      'assets/images/exit_app.json',
                      width: 80,
                      height: 80,
                    ),
                    const Text("هل تريد اغلاق التطبيق؟"),
                  ],
                ),
                actions: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                            ),
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              "إلغاء",
                              style: GoogleFonts.alexandria(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colorss().MainColor,
                            ),
                            onPressed: () => SystemNavigator.pop(),
                            child: Text(
                              "خروج",
                              style: GoogleFonts.alexandria(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }
}
