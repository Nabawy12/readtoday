import 'dart:async';
import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:readtoday/screens/Home/More.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../@single/blade.dart';
import '../../Constants/color.dart';
import '../../Model/Categories/categoris.dart';
import '../../Model/Home/home.dart';
import '../../Model/main/main.dart';
import '../../screens/archive/archive.dart';
import '../../screens/search/search.dart';
import '../../services/API/call.dart';
import '../../widgets/BuilldSectionSliderContent/SectionSlider.dart';
import '../../widgets/Drawer/drawer.dart';
import '../../widgets/Fotter/fotter.dart';
import '../../widgets/Sketlon/archive/archive.dart';
import '../../widgets/TopNews/topnews.dart';
import '../../widgets/app_bar/appBar.dart';
import '../../widgets/buildArticleContent/buildArticleContent.dart';
import '../../widgets/buildHeader_new_newss/buildHeader_new_newss.dart';
import '../../widgets/buildImageCarousel/buildImageCarousel.dart';
import '../../widgets/buildImageWithSlider/buildImageWithSlider.dart';
import '../../widgets/buildVIDEO/buildVIDEO.dart';
import '../../widgets/buildsectionGrid/buildsectionGrid.dart';
import '../../widgets/buildsectionList/buildsectionList.dart';
import '../../widgets/internetconnection/internetconcetion.dart';
import '../../widgets/sectionStory/story.dart';

class Home extends StatefulWidget {
  final String apiKey;
  final FetchMain fetchMainDataModel;

  const Home({
    super.key,
    required this.apiKey,
    required this.fetchMainDataModel,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int backPressCount = 0;

  final PageController _pageController = PageController(viewportFraction: 0.47);
  String? error;
  bool isInitialLoading = true;
  bool hasMorePosts = true;
  int currentOffset = 0;
  int _currentPage = 0;
  var logger = Logger();
  bool _isButtonVisible = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  final ScrollController main_scrollController = ScrollController();
  late Future<Map<String, dynamic>> widgets;
  bool _isAdLoaded = false;
  bool isLoading = true;
  bool floatingbutton = false;
  bool date_app_bar = false;
  bool sticky_app_bar = false;
  bool show_auto_slide = false;
  bool isLoadingLogo = true;
  bool show_box_shadow = false;
  bool isInternetConnected = true;
  List<Categoryy> categories = [];
  List<Categoryy> categories_2 = [];
  late TabController _tabController;
  int scrollFetchCounter = 0;
  late Future<Map<String, dynamic>> _futureCombinedData;
  List<Map<String, dynamic>> posts = [];
  PageController pageController = PageController();
  PageController pageController_details = PageController(viewportFraction: 0.5);

  // Fetch posts by category

  @override
  void initState() {
    super.initState();
    _handleDynamicLinks();
    /*
    fetchCategories();
*/
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (scrollFetchCounter < 2) {}
      }
    });
    if (widget.fetchMainDataModel.categories.isNotEmpty) {
      _tabController = TabController(
        length:
            widget.fetchMainDataModel.categories.isNotEmpty
                ? widget.fetchMainDataModel.categories.length + 1
                : categories.length + 1,
        vsync: this,
        initialIndex: 0,
      );
    } else {
      _tabController = TabController(
        length:
            widget.fetchMainDataModel.categories.isNotEmpty
                ? widget.fetchMainDataModel.categories.length + 1
                : categories.length + 1,
        vsync: this,
        initialIndex: 0,
      );
    }

    _tabController.addListener(() {
      if (_tabController.index != _tabController.previousIndex) {
        print("The tab index has changed to: ${_tabController.index}");
        setState(
          () {},
        ); // Force a rebuild to update the UI when the tab is changed
      }
    });
    // Add listener to monitor tab changes due to swipe

    _futureCombinedData = fetchCombinedData();

    widgets = YourColorJson().getHomeData();

    main_scrollController.addListener(() {
      if (main_scrollController.offset > 30 && !_isButtonVisible) {
        setState(() {
          _isButtonVisible = true;
          show_box_shadow = true;
        });
      } else if (main_scrollController.offset <= 30 && _isButtonVisible) {
        setState(() {
          _isButtonVisible = false;
          show_box_shadow = false;
        });
      }
    });
  }

  // Fetch logo data
  Future<void> _fetchMainData() async {
    try {
      final response = await http.post(
        Uri.parse('${YourColorJson().baseUrl}/wp-json/app/v1/main'),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        setState(() {
          widget.fetchMainDataModel ==
              FetchMain.fromJson(jsonResponse); // Populate the model
          isLoading = false;

          // Dispose the existing tab controller before creating a new one
          _tabController.dispose();

          _tabController = TabController(
            length:
                (widget.fetchMainDataModel.categories.isNotEmpty)
                    ? widget.fetchMainDataModel.categories.length + 1
                    : categories.length + 1,
            vsync: this,
            initialIndex: 0,
          );

          _tabController.addListener(() {
            if (_tabController.index != _tabController.previousIndex) {
              print("The tab index has changed to: ${_tabController.index}");
              setState(() {}); // Update UI when tab changes
            }
          });
        });
      } else {
        setState(() {
          error = 'Failed to load data';
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Failed to load data';
          isLoading = false;
        });
      }
    }
  }

  // Fetch categories from API

  // Fetch stories from API

  // Fetch combined data for home screen
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

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    main_scrollController.dispose();
    _tabController.dispose();
    pageController.dispose();
  }

  // Start auto scrolling for posts

  // Scroll to top function
  void _scrollToTop() {
    if (main_scrollController.hasClients) {
      // تحقق من وجود ScrollView
      main_scrollController.animateTo(
        0,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
      );
    }
  }

  // Build the UI for the home screen
  @override
  Widget build(BuildContext context) {
    super.build(context); // ضروري مع `AutomaticKeepAliveClientMixin`

    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      floatingActionButton:
          _isButtonVisible && floatingbutton == true
              ? FloatingActionButton(
                backgroundColor: const Color(0xffC62326),
                onPressed: _scrollToTop,
                child: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                  size: 27,
                ),
              )
              : null,
      drawer: CustomDrawer(
        shape: widget.fetchMainDataModel.archiveCategoryOptions.boxArticleMode,
        onTap: () {},
      ),
      drawerEnableOpenDragGesture:
          widget.fetchMainDataModel.topHeaderOptions.menuShowsIn == true
              ? true
              : false,
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          if (_scaffoldKey.currentState!.isDrawerOpen) {
            Navigator.pop(context);
            return false;
          }
          backPressCount++;

          if (backPressCount >= 2) {
            // عرض الحوار
            bool shouldExit = await showExitConfirmationDialog(context);
            if (shouldExit) {
              return true; // الخروج من التطبيق
            } else {
              backPressCount = 0;
              return false;
            }
          }

          Future.delayed(const Duration(seconds: 3), () {
            backPressCount = 0; // إعادة العداد للصفر بعد 3 ثوانٍ
          });

          return false; // لا تخرج من التطبيق
        },
        child: SafeArea(
          top: true,
          child: Column(
            children: [
              Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    CustomHeader(
                      view: true,
                      onTab_arrow: () => Navigator.pop(context),
                      drawer: true,
                      Icon_arrow: false,
                      onTab: () {
                        if (_tabController.index == 0) {
                          _scrollToTop();
                        } else {
                          _tabController.animateTo(0);
                          setState(() {
                            _tabController.index = 0;
                          });
                        }
                      },
                      search:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => Search(
                                    bobox_article_mode:
                                        widget
                                            .fetchMainDataModel
                                            .archiveSearchOptions
                                            .boxArticleMode,
                                  ),
                            ),
                          ),
                      isLoading: true,
                      scaffoldKey: _scaffoldKey,
                      regionTextColor: Colors.white,
                      locationTextColor: Colors.white,
                    ),
                    widget.fetchMainDataModel.topCategoriesShowsIn == true
                        ? Column(
                          children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.width > 600
                                      ? 42
                                      : 42, // Responsive height
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  double screenWidth = constraints.maxWidth;
                                  double horizontalPadding =
                                      screenWidth > 600 ? 10 : 10;
                                  double tabFontSize =
                                      screenWidth > 600 ? 16 : 16;
                                  double tabHeight =
                                      screenWidth > 600
                                          ? 40
                                          : 40; // Adjusting height

                                  return TabBar(
                                    controller: _tabController,
                                    onTap: (index) {
                                      setState(() {
                                        _tabController.index = index;
                                      });
                                    },
                                    isScrollable: true,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: horizontalPadding,
                                    ),
                                    overlayColor: const WidgetStatePropertyAll(
                                      Colors.white,
                                    ),
                                    dividerHeight: 0,
                                    indicatorColor: Colors.white,
                                    dividerColor: Colors.white,
                                    labelColor: Colors.white,
                                    unselectedLabelColor: Colors.black,
                                    tabAlignment:
                                        screenWidth > 600
                                            ? TabAlignment.center
                                            : TabAlignment.start,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    labelPadding: const EdgeInsets.only(
                                      right: 14,
                                    ),
                                    indicator: BoxDecoration(
                                      color: Colorss().MainColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    tabs: [
                                      _buildTab(
                                        'متنوع',
                                        isSelected: _tabController.index == 0,
                                        height: tabHeight,
                                      ),
                                      if (widget
                                          .fetchMainDataModel
                                          .categories
                                          .isNotEmpty)
                                        ...widget.fetchMainDataModel.categories
                                            .map((category) {
                                              bool isSelected =
                                                  _tabController.index ==
                                                  widget
                                                          .fetchMainDataModel
                                                          .categories
                                                          .indexOf(category) +
                                                      1;
                                              return _buildTab(
                                                category.name,
                                                isSelected: isSelected,
                                                height: tabHeight,
                                              );
                                            })
                                            .toList(),
                                      if (widget
                                          .fetchMainDataModel
                                          .categories
                                          .isEmpty)
                                        ...categories.map((category) {
                                          bool isSelected =
                                              _tabController.index ==
                                              categories.indexOf(category) + 1;
                                          return _buildTab(
                                            category.name!,
                                            isSelected: isSelected,
                                            height: tabHeight,
                                          );
                                        }).toList(),
                                    ],
                                    labelStyle: GoogleFonts.alexandria(
                                      fontWeight: FontWeight.w600,
                                      fontSize: tabFontSize,
                                    ),
                                    unselectedLabelStyle:
                                        GoogleFonts.alexandria(
                                          fontWeight: FontWeight.w400,
                                          fontSize: tabFontSize,
                                        ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        )
                        : Container(),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics:
                      widget.fetchMainDataModel.topCategoriesShowsIn == true
                          ? const AlwaysScrollableScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    RefreshIndicator(
                      color: const Color(0xffC62326),
                      backgroundColor: Colors.white,
                      onRefresh: () async {
                        setState(() {
                          isLoading = true;
                        });

                        await _fetchMainData();

                        setState(() {
                          _futureCombinedData = fetchCombinedData();
                          isLoading = false;
                        });
                      },
                      child: FutureBuilder<Map<String, dynamic>>(
                        future: _futureCombinedData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: Skeleton_archive());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: noInternetConnectionWidget(() async {
                                setState(() {
                                  isLoading = true;
                                });

                                await _fetchMainData();

                                setState(() {
                                  _futureCombinedData = fetchCombinedData();
                                  isLoading = false;
                                });
                              }),
                            );
                          } else if (snapshot.hasData) {
                            final data =
                                snapshot.data!['userData']
                                    as Map<String, dynamic>;

                            List<Widget> widgetList = [];

                            // Iterate through the data (which contains widget-related information)
                            data.forEach((key, widgetData) {
                              List<Post> posts = [];

                              // Check if posts exist in the widgetData and parse them
                              if (widgetData['posts'] != null) {
                                List<dynamic> postList = widgetData['posts'];
                                posts =
                                    postList
                                        .map((post) => Post.fromJson(post))
                                        .toList();
                              } else {
                                posts =
                                    []; // Default to an empty list if no posts exist
                              }

                              // Handle each widget type based on the 'Widget_type' field
                              if (widgetData['Widget_type'] ==
                                  'buildImageWithSlider') {
                                widgetList.add(
                                  buildImageWithSliderr(
                                    posts: posts,
                                    title: widgetData['title'] ?? '',
                                    shape:
                                        widget
                                            .fetchMainDataModel
                                            .archiveCategoryOptions
                                            .boxArticleMode,
                                  ),
                                );
                              } else if (widgetData['Widget_type'] ==
                                  'buildImageCarousel') {
                                widgetList.add(
                                  buildImageCarousel(
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => More_Home(
                                                shapemore:
                                                    widget
                                                        .fetchMainDataModel
                                                        .archiveWidgetsOptions
                                                        .boxArticleMode,
                                                WidgetID:
                                                    widgetData['WidgetID'],
                                                per_page: "10",
                                                page: "1",
                                              ),
                                        ),
                                      );
                                      print(widgetData['WidgetID']);
                                    },
                                    posts,
                                    _pageController,
                                    widgetData['title'] ?? '',
                                  ),
                                );
                              } else if (widgetData['Widget_type'] ==
                                  'buildArticleContent_diffent') {
                                widgetList.add(
                                  buildArticleContent(
                                    posts,
                                    context,
                                    widgetData['title'] ?? '',
                                    widget
                                        .fetchMainDataModel
                                        .archiveCategoryOptions
                                        .boxArticleMode,
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => More_Home(
                                                shapemore:
                                                    widget
                                                        .fetchMainDataModel
                                                        .archiveWidgetsOptions
                                                        .boxArticleMode,
                                                WidgetID:
                                                    widgetData['WidgetID'],
                                                per_page: "10",
                                                page: "1",
                                              ),
                                        ),
                                      );
                                      print(widgetData['WidgetID']);
                                    },
                                  ),
                                );
                              } else if (widgetData['Widget_type'] ==
                                  'Section_video') {
                                widgetList.add(
                                  buildVIDEO(
                                    posts,
                                    widgetData['title'] ?? '',
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => More_Home(
                                                shapemore:
                                                    widget
                                                        .fetchMainDataModel
                                                        .archiveWidgetsOptions
                                                        .boxArticleMode,
                                                WidgetID:
                                                    widgetData['WidgetID'] ?? 0,
                                                per_page: "10",
                                                page: "1",
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else if (widgetData['Widget_type'] ==
                                  'buildHeader_new_news') {
                                widgetList.add(
                                  buildHeader_new_newss(
                                    posts,
                                    widgetData['title'] ?? '',
                                    widget
                                        .fetchMainDataModel
                                        .archiveCategoryOptions
                                        .boxArticleMode,
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => More_Home(
                                                shapemore:
                                                    widget
                                                        .fetchMainDataModel
                                                        .archiveWidgetsOptions
                                                        .boxArticleMode,
                                                WidgetID:
                                                    widgetData['WidgetID'],
                                                per_page: "10",
                                                page: "1",
                                              ),
                                        ),
                                      );
                                      print(widgetData['WidgetID']);
                                    },
                                    pageController,
                                    context,
                                    _currentPage,
                                  ),
                                );
                              } else if (widgetData['Widget_type'] ==
                                  'section_grid') {
                                widgetList.add(
                                  buildsectionGrid(
                                    posts,
                                    widgetData['title'] ?? '',
                                    widget
                                        .fetchMainDataModel
                                        .archiveCategoryOptions
                                        .boxArticleMode,
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => More_Home(
                                                shapemore:
                                                    widget
                                                        .fetchMainDataModel
                                                        .archiveWidgetsOptions
                                                        .boxArticleMode,
                                                WidgetID:
                                                    widgetData['WidgetID'],
                                                per_page: "10",
                                                page: "1",
                                              ),
                                        ),
                                      );
                                      print(widgetData['WidgetID']);
                                    },
                                    context,
                                  ),
                                );
                              } else if (widgetData['Widget_type'] ==
                                  'buildsectionList') {
                                widgetList.add(
                                  buildsectionList(
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => More_Home(
                                                shapemore:
                                                    widget
                                                        .fetchMainDataModel
                                                        .archiveWidgetsOptions
                                                        .boxArticleMode,
                                                WidgetID:
                                                    widgetData['WidgetID'],
                                                per_page: "10",
                                                page: "1",
                                              ),
                                        ),
                                      );
                                      print(widgetData['WidgetID']);
                                    },
                                    posts,
                                    widgetData['title'] ?? '',
                                    widget
                                        .fetchMainDataModel
                                        .archiveCategoryOptions
                                        .boxArticleMode,
                                    context,
                                  ),
                                );
                              } else if (widgetData['Widget_type'] ==
                                  'buildHeaderTopNews') {
                                widgetList.add(
                                  BuildHeaderTopNews(
                                    posts: posts,
                                    title: widgetData['title'] ?? '',
                                  ),
                                );
                              } else if (widgetData['Widget_type'] ==
                                  'buildImageCarousel_slider_details') {
                                widgetList.add(
                                  buildImageCarousel_slider_details(
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => More_Home(
                                                shapemore:
                                                    widget
                                                        .fetchMainDataModel
                                                        .archiveWidgetsOptions
                                                        .boxArticleMode,
                                                WidgetID:
                                                    widgetData['WidgetID'],
                                                per_page: "10",
                                                page: "1",
                                              ),
                                        ),
                                      );
                                      print(widgetData['WidgetID']);
                                    },
                                    posts,
                                    pageController_details,
                                    widgetData['title'] ?? '',
                                    widget
                                        .fetchMainDataModel
                                        .archiveCategoryOptions
                                        .boxArticleMode,
                                  ),
                                );
                              } else if (widgetData['Widget_type'] ==
                                  'StoryListViewWidget') {
                                widgetList.add(
                                  StoryListViewWidget(
                                    posts: posts,
                                    title: widgetData['title'] ?? '',
                                    shape:
                                        widget
                                            .fetchMainDataModel
                                            .archiveCategoryOptions
                                            .boxArticleMode,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => More_Home(
                                                story: true,
                                                WidgetID:
                                                    widgetData['WidgetID'],
                                                per_page: "10",
                                                page: "1",
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                            });

                            // Return the ListView with dynamically generated widgets
                            return ListView(
                              controller: main_scrollController,
                              children: [
                                ...widgetList,
                                const SizedBox(height: 20),
                                footer(
                                  image: widget.fetchMainDataModel.logo,
                                  text:
                                      widget
                                          .fetchMainDataModel
                                          .footerOptions
                                          .footerDescription,
                                  text_social:
                                      widget
                                          .fetchMainDataModel
                                          .footerOptions
                                          .socialTitle,
                                  show_logo:
                                      widget
                                          .fetchMainDataModel
                                          .footerOptions
                                          .logoShowsIn,
                                  show_socil:
                                      widget
                                          .fetchMainDataModel
                                          .footerOptions
                                          .socialShowsIn,
                                  show_text:
                                      widget
                                          .fetchMainDataModel
                                          .footerOptions
                                          .descriptionShowsIn,
                                  onTap_facebook:
                                      () => openLink(
                                        widget
                                            .fetchMainDataModel
                                            .socialItems
                                            .facebook,
                                      ),
                                  onTap_twitter:
                                      () => openLink(
                                        widget
                                            .fetchMainDataModel
                                            .socialItems
                                            .twitter,
                                      ),
                                  onTap_linkedIn:
                                      () => openLink(
                                        widget
                                            .fetchMainDataModel
                                            .socialItems
                                            .linkedin,
                                      ),
                                  onTap_tiktok:
                                      () => openLink(
                                        widget
                                            .fetchMainDataModel
                                            .socialItems
                                            .youtube,
                                      ),
                                  onTap_instgrame:
                                      () => openLink(
                                        widget
                                            .fetchMainDataModel
                                            .socialItems
                                            .instagram,
                                      ),
                                ),
                              ],
                            );
                          } else {
                            return Center(
                              child: noInternetConnectionWidget(() async {
                                setState(() {
                                  isLoading = true;
                                });

                                await _fetchMainData();

                                setState(() {
                                  _futureCombinedData = fetchCombinedData();
                                  isLoading = false;
                                });
                              }),
                            );
                          }
                        },
                      ),
                    ),
                    if (widget.fetchMainDataModel.categories.isNotEmpty)
                      ...widget.fetchMainDataModel.categories.map((category) {
                        return Archive(
                          descintion: true,
                          from_categories: true,
                          onTab: () {
                            _tabController.animateTo(0);
                            if (_tabController.index != 0) {
                              setState(() {
                                _tabController.index = 0;
                              });
                            }
                          },
                          id: category.id,
                          name: category.name,
                          title_show: false,
                          box_article_mode:
                              widget
                                  .fetchMainDataModel
                                  .archiveCategoryOptions
                                  .boxArticleMode,
                        );
                      }).toList(),
                    if (widget.fetchMainDataModel.categories.isEmpty)
                      ...categories.map((category) {
                        return Archive(
                          descintion: true,
                          from_categories: true,
                          onTab: () {
                            _tabController.animateTo(0);
                            if (_tabController.index != 0) {
                              setState(() {
                                _tabController.index = 0;
                              });
                            }
                          },
                          id: category.id,
                          name: category.name!,
                          title_show: false,
                          box_article_mode:
                              widget
                                  .fetchMainDataModel
                                  .archiveCategoryOptions
                                  .boxArticleMode,
                        );
                      }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                    ), // Lottie animation
                    const Text("هل تريد اغلاق التطبيق؟"),
                  ],
                ),
                actions: [
                  // Centering the buttons horizontally
                  Center(
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Centering the buttons
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
                        const SizedBox(
                          width: 7,
                        ), // Adds space between the buttons
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('_isAdLoaded', _isAdLoaded));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void _handleDynamicLinks() async {
    // Handle the app launch from a dynamic link
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(data);

    // Also, listen for dynamic links while the app is running in the background or foreground
    FirebaseDynamicLinks.instance.onLink
        .listen((dynamicLinkData) {
          _handleDeepLink(dynamicLinkData);
        })
        .onError((error) {
          // Handle errors
          print('Dynamic Link Failed: $error');
        });
  }

  void _handleDeepLink(PendingDynamicLinkData? data) {
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      // Extract the parameter (for example, an 'id' parameter)
      final String? id = deepLink.queryParameters['id'];

      if (id != null) {
        // Navigate to the desired page and pass the id
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleServicesPage(id: int.parse(id)),
          ),
        );
      }
    }
  }
}

Widget _buildTab(
  String title, {
  required bool isSelected,
  required double height,
}) {
  return Container(
    height: height,
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
    decoration: BoxDecoration(
      color:
          isSelected ? Colors.transparent : Colors.grey[300]!.withOpacity(0.3),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Tab(text: title),
  );
}
