import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../@single/blade.dart';
import '../../Bloc/single_section/singel_section.dart';
import '../../Constants/color.dart';
import '../../Model/Archives/archives.dart';
import '../../Model/main/main.dart';
import '../../YC Style/Image.dart';
import '../../widgets/Drawer/drawer.dart';
import '../../widgets/Fotter/fotter.dart';
import '../../widgets/Sketlon/Search/search.dart';
import '../../widgets/Sketlon/archive/archive.dart';
import '../../widgets/Sketlon/imageCusrssor/imagecurssor.dart';
import '../../widgets/app_bar/appBar.dart';
import '../../widgets/internetconnection/internetconcetion.dart';
import '../../widgets/style_8/style_8.dart';
import '../Home/home.dart';
import '../search/search.dart';

class Archive extends StatefulWidget {
  final int id;
  final String name;
  final String? box_article_mode;
  final bool title_show;
  final bool from_categories;
  final bool descintion;
  final void Function()? onTab;
  final String? rewardID_show;
  final String? rewardID;

  const Archive({
    super.key,
    required this.id,
    required this.name,
    required this.title_show,
    this.onTab,
    this.descintion = false,
    required this.from_categories,
    required this.box_article_mode,
    required this.rewardID_show,
    required this.rewardID,
  });

  @override
  State<Archive> createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive>
    with AutomaticKeepAliveClientMixin<Archive> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<ArchivePost> posts = [];

  bool isLoading = false;

  bool isInitialLoading = true;
  bool logo = true;

  bool isLoadingLogo = true;

  bool hasMorePosts = true;

  bool date_app_bar = true;

  final ScrollController _scrollController = ScrollController();
  bool _isAdLoaded = false;
  RewardedAd? _rewardedAd;
  int currentPage = 1;
  int postsPerPage = 10;
  FetchMain? _fetchMainDataModel;
  String? title;
  ArchivesModel? archivesModel;

  // Load the rewarded ad
  void _loadAndShowRewardedAd() {
    RewardedAd.load(
      adUnitId: widget.rewardID.toString(),
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          setState(() {
            _rewardedAd = ad;
            _isAdLoaded = true;
          });
          // عرض الإعلان فور تحميله
          _showRewardedAd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('فشل تحميل الإعلان المكافأة: $error');
        },
      ),
    );
  }

  // عرض الإعلان المكافأة عند تحميله
  void _showRewardedAd() {
    if (_isAdLoaded) {
      _rewardedAd?.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('المستخدم حصل على مكافأة: ${reward.amount} ${reward.type}');
        },
      );
    } else {
      print('الإعلان غير محمل بعد.');
    }
  }

  Future<void> fetchData() async {
    try {
      // Set isInitialLoading to true before starting the API calls
      setState(() {
        isInitialLoading = true;
      });

      // Run both methods concurrently and wait for them to finish
      await Future.wait([_fetchMainData(), fetchPostsByCategory(widget.id)]);
    } finally {
      // Set isInitialLoading to false after both API calls are done
      if (mounted) {
        setState(() {
          isInitialLoading = false;
        });
      }
    }
  }

  Future<void> _fetchMainData() async {
    try {
      final response = await http.post(
        Uri.parse('https://demo.elboshy.com/new_api/wp-json/app/v1/main'),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        setState(() {
          _fetchMainDataModel = FetchMain.fromJson(
            jsonResponse,
          ); // Populate the model
        });
      } else {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> fetchPostsByCategory(int categoryId) async {
    try {
      final url = Uri.parse(
        'https://demo.elboshy.com/new_api/wp-json/app/v1/get_archives?term_id=${widget.id}&Paged=$currentPage',
      );
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse.isNotEmpty) {
          // Log the whole response

          if (mounted) {
            setState(() {
              archivesModel = ArchivesModel.fromJson(jsonResponse);
              posts.addAll(archivesModel!.posts);
              if (!archivesModel!.endQuery == false) {
                hasMorePosts = false;
              } else {
                hasMorePosts = true;
              }
            });
          }
        } else {
          throw Exception('No data found');
        }
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isInitialLoading =
              false; // Make sure loading is set to false on error
        });
      }
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  void loadMorePosts() async {
    if (!isLoading && hasMorePosts) {
      setState(() {
        isLoading = true;
      });

      currentPage++;
      await fetchPostsByCategory(widget.id);

      setState(() {
        isLoading = false;
      });
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
  void initState() {
    super.initState();
    widget.rewardID_show == "on" && widget.title_show == true
        ? _loadAndShowRewardedAd()
        : null;
    fetchData();
    print("=============================${widget.id}");

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading &&
          archivesModel!.endQuery == false) {
        loadMorePosts(); // Call loadMorePosts when reaching the end
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      drawerEnableOpenDragGesture:
          _fetchMainDataModel?.topHeaderOptions.menuShowsIn == true
              ? true
              : false,
      backgroundColor: Colors.white,
      drawer: CustomDrawer(
        shape: _fetchMainDataModel?.archiveCategoryOptions.boxArticleMode,
        onTap: () => Navigator.pop(context),
      ),
      key: _scaffoldKey,
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: SafeArea(
          child: RefreshIndicator(
            color: const Color(0xffC62326),
            backgroundColor: Colors.white,
            onRefresh: () async {
              archivesModel!.posts.clear();
              posts.clear();
              setState(() {
                isInitialLoading = true;
                currentPage = 1;
              });
              await fetchData();
            },
            child: Column(
              children: [
                widget.title_show == true
                    ? CustomHeader(
                      view: true,
                      onTab_arrow: () => Navigator.pop(context),
                      drawer: true,
                      Icon_arrow: true,
                      onTab: () {
                        isInitialLoading == true
                            ? null
                            : Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => Home(
                                      fetchMainDataModel: _fetchMainDataModel!,
                                      apiKey: '9nf9EeJ4PflFeUFQIPKfJLy4',
                                    ),
                              ),
                              (route) => false,
                            );
                      },
                      search:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => Search(
                                    bobox_article_mode:
                                        _fetchMainDataModel!
                                            .archiveSearchOptions
                                            .boxArticleMode,
                                  ),
                            ),
                          ),
                      isLoading: isInitialLoading,
                      scaffoldKey: _scaffoldKey,
                      regionTextColor: Colors.white,
                      locationTextColor: Colors.white,
                    )
                    : Container(),
                isInitialLoading
                    ? Expanded(
                      child:
                          widget.box_article_mode == 'customSection_list'
                              ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                ),
                                shrinkWrap: true,
                                itemCount: 10,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xffe5eaef),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: customSectionSkeleton(),
                                  );
                                },
                              )
                              : widget.box_article_mode ==
                                      'buildsection_slider' ||
                                  widget.box_article_mode ==
                                      'buildImageCarousel'
                              ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                child: SkeletonGrid(),
                              )
                              : Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                child: Skeleton_archive(),
                              ),
                    )
                    : posts.isEmpty
                    ? Center(
                      child: noInternetConnectionWidget(() async {
                        print("Fetched posts: ${posts.length}");
                        setState(() {
                          isInitialLoading = true;
                          currentPage = 1;
                        });
                        await fetchData();
                      }),
                    )
                    : widget.box_article_mode != "buildsection_slider" &&
                        widget.box_article_mode != "buildImageCarousel"
                    ? widget.from_categories == true
                        ? Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            shrinkWrap: true,
                            controller: _scrollController,
                            itemCount: posts.length + 2 + (isLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == posts.length + 1 && isLoading) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child:
                                      widget.box_article_mode ==
                                              'customSection_list'
                                          ? Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                            ),
                                            child: ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: 10,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  margin: EdgeInsets.only(
                                                    bottom: 10,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 0,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: const Color(
                                                        0xffe5eaef,
                                                      ),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child:
                                                      customSectionSkeleton(),
                                                );
                                              },
                                            ),
                                          )
                                          : widget.box_article_mode ==
                                                  'buildsection_slider' ||
                                              widget.box_article_mode ==
                                                  'buildImageCarousel'
                                          ? SkeletonGrid()
                                          : Skeleton_archive(),
                                );
                              }
                              if (index == 0) {
                                if (widget.descintion != true) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        if (archivesModel!
                                            .archiveOptions
                                            .sectionTitleShowsin)
                                          Text(archivesModel!.title),
                                        const SizedBox(height: 10),
                                        if (archivesModel!
                                                .archiveOptions
                                                .sectionDescriptionShowsin &&
                                            archivesModel!
                                                .description
                                                .isNotEmpty)
                                          ReadMoreText(
                                            archivesModel!.description,
                                            moreStyle: GoogleFonts.alexandria(
                                              color: Colorss().MainColor,
                                            ),
                                            lessStyle: GoogleFonts.alexandria(
                                              color: Colorss().MainColor,
                                            ),
                                            trimExpandedText: " عرض القليل",
                                            trimCollapsedText: ' عرض المزيد',
                                            trimMode: TrimMode.Line,
                                            trimLines: 2,
                                            style: GoogleFonts.alexandria(
                                              fontSize: 13,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              } else if (index ==
                                  posts.length + (isLoading ? 2 : 1)) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      footer(
                                        image: _fetchMainDataModel!.logo,
                                        text:
                                            _fetchMainDataModel!
                                                .footerOptions
                                                .footerDescription,
                                        text_social:
                                            _fetchMainDataModel!
                                                .footerOptions
                                                .socialTitle,
                                        show_logo:
                                            _fetchMainDataModel!
                                                .footerOptions
                                                .logoShowsIn,
                                        show_socil:
                                            _fetchMainDataModel!
                                                .footerOptions
                                                .socialShowsIn,
                                        show_text:
                                            _fetchMainDataModel!
                                                .footerOptions
                                                .socialShowsIn,
                                        onTap_facebook:
                                            () => openLink(
                                              _fetchMainDataModel!
                                                  .socialItems
                                                  .facebook,
                                            ),
                                        onTap_twitter:
                                            () => openLink(
                                              _fetchMainDataModel!
                                                  .socialItems
                                                  .twitter,
                                            ),
                                        onTap_linkedIn:
                                            () => openLink(
                                              _fetchMainDataModel!
                                                  .socialItems
                                                  .linkedin,
                                            ),
                                        onTap_tiktok:
                                            () => openLink(
                                              _fetchMainDataModel!
                                                  .socialItems
                                                  .youtube,
                                            ),
                                        onTap_instgrame:
                                            () => openLink(
                                              _fetchMainDataModel!
                                                  .socialItems
                                                  .instagram,
                                            ),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (index == posts.length) {
                                final post = posts[index - (isLoading ? 2 : 1)];
                                return getShapeWidget(
                                  context,
                                  widget.box_article_mode,
                                  post,
                                  _fetchMainDataModel!
                                      .archiveCategoryOptions
                                      .boxArticleMode,
                                  _fetchMainDataModel!.adsOptions.RewardedId,
                                  _fetchMainDataModel!
                                      .adsOptions
                                      .enableRewardedAds,
                                );
                              } else {
                                final post = posts[index - (isLoading ? 2 : 1)];
                                return getShapeWidget(
                                  context,
                                  widget.box_article_mode,
                                  post,
                                  _fetchMainDataModel!
                                      .archiveCategoryOptions
                                      .boxArticleMode,
                                  _fetchMainDataModel!.adsOptions.RewardedId,
                                  _fetchMainDataModel!
                                      .adsOptions
                                      .enableRewardedAds,
                                );
                              }
                            },
                          ),
                        )
                        : Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            shrinkWrap: true,
                            controller: _scrollController,
                            itemCount: posts.length + 2 + (isLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == posts.length + 1 && isLoading) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                  ),
                                  child:
                                      widget.box_article_mode ==
                                              'customSection_list'
                                          ? Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                            ),
                                            child: ListView.builder(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 10,
                                                  ),
                                              shrinkWrap: true,
                                              itemCount: 10,
                                              itemBuilder: (context, index) {
                                                return customSectionSkeleton();
                                              },
                                            ),
                                          )
                                          : widget.box_article_mode ==
                                                  'buildsection_slider' ||
                                              widget.box_article_mode ==
                                                  'buildImageCarousel'
                                          ? SkeletonGrid()
                                          : Skeleton_archive(),
                                );
                              }
                              if (index == 0) {
                                if (widget.descintion != true) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        if (archivesModel!
                                            .archiveOptions
                                            .sectionTitleShowsin)
                                          Text(archivesModel!.title),
                                        const SizedBox(height: 10),
                                        if (archivesModel!
                                                .archiveOptions
                                                .sectionDescriptionShowsin &&
                                            archivesModel!
                                                .description
                                                .isNotEmpty)
                                          ReadMoreText(
                                            archivesModel!.description,
                                            moreStyle: GoogleFonts.alexandria(
                                              color: Colorss().MainColor,
                                            ),
                                            lessStyle: GoogleFonts.alexandria(
                                              color: Colorss().MainColor,
                                            ),
                                            trimExpandedText: " عرض القليل",
                                            trimCollapsedText: ' عرض المزيد',
                                            trimMode: TrimMode.Line,
                                            trimLines: 2,
                                            style: GoogleFonts.alexandria(
                                              fontSize: 13,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              } else if (index ==
                                  posts.length + (isLoading ? 2 : 1)) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      footer(
                                        image: _fetchMainDataModel!.logo,
                                        text:
                                            _fetchMainDataModel!
                                                .footerOptions
                                                .footerDescription,
                                        text_social:
                                            _fetchMainDataModel!
                                                .footerOptions
                                                .socialTitle,
                                        show_logo:
                                            _fetchMainDataModel!
                                                .footerOptions
                                                .logoShowsIn,
                                        show_socil:
                                            _fetchMainDataModel!
                                                .footerOptions
                                                .socialShowsIn,
                                        show_text:
                                            _fetchMainDataModel!
                                                .footerOptions
                                                .socialShowsIn,
                                        onTap_facebook:
                                            () => openLink(
                                              _fetchMainDataModel!
                                                  .socialItems
                                                  .facebook,
                                            ),
                                        onTap_twitter:
                                            () => openLink(
                                              _fetchMainDataModel!
                                                  .socialItems
                                                  .twitter,
                                            ),
                                        onTap_linkedIn:
                                            () => openLink(
                                              _fetchMainDataModel!
                                                  .socialItems
                                                  .linkedin,
                                            ),
                                        onTap_tiktok:
                                            () => openLink(
                                              _fetchMainDataModel!
                                                  .socialItems
                                                  .youtube,
                                            ),
                                        onTap_instgrame:
                                            () => openLink(
                                              _fetchMainDataModel!
                                                  .socialItems
                                                  .instagram,
                                            ),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (index == posts.length) {
                                final post = posts[index - (isLoading ? 2 : 1)];
                                return getshapetags(
                                  context,
                                  widget.box_article_mode,
                                  post,
                                  _fetchMainDataModel
                                      ?.archiveCategoryOptions
                                      .boxArticleMode,
                                  _fetchMainDataModel!.adsOptions.RewardedId,
                                  _fetchMainDataModel!
                                      .adsOptions
                                      .enableRewardedAds,
                                );
                              } else {
                                final post = posts[index - (isLoading ? 2 : 1)];
                                return getshapetags(
                                  context,
                                  widget.box_article_mode,
                                  post,
                                  _fetchMainDataModel
                                      ?.archiveCategoryOptions
                                      .boxArticleMode,
                                  _fetchMainDataModel!.adsOptions.RewardedId,
                                  _fetchMainDataModel!
                                      .adsOptions
                                      .enableRewardedAds,
                                );
                              }
                            },
                          ),
                        )
                    : widget.from_categories != true
                    ? Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        primary: false,
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              widget.box_article_mode ==
                                          'buildsection_slider' ||
                                      widget.box_article_mode ==
                                          'buildImageCarousel'
                                  ? 2
                                  : 5,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                          childAspectRatio:
                              widget.box_article_mode != "buildsection_slider"
                                  ? 0.8
                                  : 0.6,
                        ),
                        itemCount: posts.length + (isLoading ? 2 : 0),
                        itemBuilder: (context, index) {
                          if (isLoading && index >= posts.length) {
                            return widget.box_article_mode ==
                                    'customSection_list'
                                ? Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    left: 15,
                                    right: 15,
                                  ),
                                  child: ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 10,
                                    ),
                                    shrinkWrap: true,
                                    itemCount: 10,
                                    itemBuilder: (context, index) {
                                      return customSectionSkeleton();
                                    },
                                  ),
                                )
                                : widget.box_article_mode ==
                                        'buildsection_slider' ||
                                    widget.box_article_mode ==
                                        'buildImageCarousel'
                                ? const SkeletonServiceCard()
                                : Skeleton_archive();
                          }
                          final post = posts[index];
                          if (index == posts.length && isLoading) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              child:
                                  widget.box_article_mode ==
                                          'customSection_list'
                                      ? Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: ListView.builder(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          shrinkWrap: true,
                                          itemCount: 10,
                                          itemBuilder: (context, index) {
                                            return customSectionSkeleton();
                                          },
                                        ),
                                      )
                                      : widget.box_article_mode ==
                                              'buildsection_slider' ||
                                          widget.box_article_mode ==
                                              'buildImageCarousel'
                                      ? const Center(
                                        child: SkeletonServiceCard(),
                                      )
                                      : Skeleton_archive(),
                            );
                          }
                          return getShapeWidget(
                            context,
                            widget.box_article_mode,
                            post,
                            _fetchMainDataModel!
                                .archiveCategoryOptions
                                .boxArticleMode,
                            _fetchMainDataModel!.adsOptions.RewardedId,
                            _fetchMainDataModel!.adsOptions.enableRewardedAds,
                          );
                        },
                      ),
                    )
                    : Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        primary: false,
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              widget.box_article_mode ==
                                          'buildsection_slider' ||
                                      widget.box_article_mode ==
                                          'buildImageCarousel'
                                  ? 2
                                  : 5,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 5,
                          childAspectRatio:
                              widget.box_article_mode != "buildsection_slider"
                                  ? 0.8
                                  : 0.6,
                        ),
                        itemCount: posts.length + (isLoading ? 2 : 0),
                        // Removed the + (isLoading ? 1 : 0)
                        itemBuilder: (context, index) {
                          if (isLoading && index >= posts.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              child:
                                  widget.box_article_mode ==
                                          'customSection_list'
                                      ? Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: ListView.builder(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 10,
                                          ),
                                          shrinkWrap: true,
                                          itemCount: 10,
                                          itemBuilder: (context, index) {
                                            return customSectionSkeleton();
                                          },
                                        ),
                                      )
                                      : widget.box_article_mode ==
                                              'buildsection_slider' ||
                                          widget.box_article_mode ==
                                              'buildImageCarousel'
                                      ? const Padding(
                                        padding: EdgeInsets.only(bottom: 60),
                                        child: SkeletonServiceCard(),
                                      )
                                      : Skeleton_archive(),
                            );
                          }

                          final post = posts[index];
                          return getshapetags(
                            context,
                            widget.box_article_mode,
                            post,
                            _fetchMainDataModel
                                    ?.archiveCategoryOptions
                                    .boxArticleMode ??
                                '',
                            _fetchMainDataModel!.adsOptions.RewardedId,
                            _fetchMainDataModel!.adsOptions.enableRewardedAds,
                          );
                        },
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Widget getShapeWidget(
  BuildContext context,
  String? shape,
  ArchivePost post,
  shapecategory,
  String? rewardID,
  String? rewardID_show,
) {
  double screenWidth = MediaQuery.of(context).size.width;
  double containerWidth = screenWidth * 0.9;
  double imageHeight = screenWidth * 0.35;
  double containerMargin = screenWidth * 0.03;
  double screenHeight = MediaQuery.of(context).size.height;
  double paddingHorizontal = screenWidth * 0.03;
  double paddingVertical = screenWidth * 0.02;
  final Map<String, Widget Function(ArchivePost post)> shapeWidgets = {
    "buildsection_archive":
        (post) => InkWell(
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => SingleServicesPage(
                        id: post.id,
                        id_reward: rewardID.toString(),
                        id_show: rewardID_show.toString(),
                      ),
                ),
              ),
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: screenWidth * 0.02,
              horizontal: screenWidth * 0.03,
            ),
            width: containerWidth,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffe5eaef)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenWidth * 0.04),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Image_style(
                    network: true,
                    height: imageHeight,
                    width: double.infinity,
                    url: post.thumbnail ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),
                post.categories.isNotEmpty
                    ? InkWell(
                      overlayColor: const WidgetStatePropertyAll(
                        Colors.transparent,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => Archive(
                                  from_categories: true,
                                  rewardID: rewardID,
                                  rewardID_show: rewardID_show,
                                  name: post.categories[0].name,
                                  id: post.categories[0].id,
                                  title_show: true,
                                  box_article_mode: shapecategory,
                                  onTab: () {
                                    Navigator.pop(context);
                                  },
                                ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(screenWidth * 0.012),
                          decoration: BoxDecoration(
                            color: const Color(0xffc62326),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            post.categories[0].name,
                            style: GoogleFonts.alexandria(
                              fontSize: screenWidth * 0.025,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                    : Container(),
                SizedBox(height: screenWidth * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: HtmlWidget(
                    post.title,
                    textStyle: GoogleFonts.alexandria(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Text(
                    post.date,
                    style: GoogleFonts.alexandria(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: screenWidth * 0.04),
              ],
            ),
          ),
        ),
    "customSection_list":
        (post) => Container(
          margin: EdgeInsets.only(
            bottom: containerMargin,
            left: containerMargin,
            right: containerMargin,
          ),
          child: InkWell(
            overlayColor: const WidgetStatePropertyAll(Colors.white),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => SingleServicesPage(
                        id: post.id,
                        id_reward: rewardID.toString(),
                        id_show: rewardID_show.toString(),
                      ),
                ),
              );
            },
            child: customSection_list(
              category:
                  post.categories.isNotEmpty &&
                          post.categories.first.name.isNotEmpty
                      ? post.categories.first.name
                      : '',

              subtitle: post.title,
              imageUrl: post.thumbnail ?? '',
              titleColor: Colors.black,
              subtitleColor: Colors.black,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => Archive(
                          rewardID: rewardID,
                          rewardID_show: rewardID_show,
                          box_article_mode: shapecategory,
                          id: post.categories[0].id,
                          name: post.categories[0].name,
                          title_show: true,
                          from_categories: true,
                        ),
                  ),
                );
              },
              imageBorderColor: Colors.white,
            ),
          ),
        ),
    "buildsingleArtctile":
        (post) => Padding(
          padding: EdgeInsets.symmetric(
            vertical: paddingVertical,
            horizontal: paddingHorizontal,
          ),
          child: SingleSection(
            rewardID: rewardID,
            rewardID_show: rewardID_show,
            shape: shape!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => SingleServicesPage(
                        id: post.id,
                        id_reward: rewardID.toString(),
                        id_show: rewardID_show.toString(),
                      ),
                ),
              );
            },
            Name: post.categories[0].name,
            idCategory: post.categories[0].id,
            imageUrl: post.thumbnail ?? '',
            category: post.categories[0].name,
            cleanTitle1: post.title,
            cleanContent: post.content,
          ),
        ),
    "buildsection_slider":
        (post) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => SingleServicesPage(
                          id: post.id,
                          id_reward: rewardID.toString(),
                          id_show: rewardID_show.toString(),
                        ),
                  ),
                );
              },
              child: Container(
                width: containerWidth,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffe5eaef)),
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenWidth * 0.01,
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Image_style(
                              network: true,
                              url: post.thumbnail,
                              bottomLeft: 0,
                              topRight: 0,
                              topLeft: 0,
                              bottomRight: 0,
                              fit: BoxFit.contain,
                              height: imageHeight,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.02),
                      post.categories.isNotEmpty
                          ? InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => Archive(
                                        rewardID: rewardID,
                                        rewardID_show: rewardID_show,
                                        box_article_mode: shape,
                                        from_categories: true,
                                        id: post.categories.first.id,
                                        name: post.categories.first.name,
                                        title_show: true,
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: screenWidth * 0.00,
                                horizontal: screenWidth * 0.02,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xffc62326),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                post.categories.first.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.alexandria(
                                  fontSize: screenWidth * 0.025,
                                  color: Colors.white,
                                  height: 1.7,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          )
                          : Container(),
                      SizedBox(height: screenWidth * 0.01),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.alexandria(
                                fontSize: screenWidth * 0.03,
                                color: Colors.black,
                                height: 1.7,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: screenWidth * 0.01),
                            Wrap(
                              children: [
                                Text(
                                  post.content,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.alexandria(
                                    fontSize: screenWidth * 0.03,
                                    color: Colors.grey,
                                    height: 1.6,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
    "buildImageCarousel":
        (post) => InkWell(
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => SingleServicesPage(
                      id: post.id,
                      id_reward: rewardID.toString(),
                      id_show: rewardID_show.toString(),
                    ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffe5eaef)),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02,
              vertical: screenHeight * 0.01,
            ),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image_style(
                    network: true,
                    url: post.thumbnail,
                    bottomLeft: 0,
                    topRight: 0,
                    topLeft: 0,
                    bottomRight: 0,
                    fit: BoxFit.contain,
                    height: screenHeight * 0.15,
                    // Scales based on screen height
                    width: double.infinity,
                  ),
                  SizedBox(height: screenHeight * 0.02), // Dynamic spacing
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      post.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.alexandria(
                        fontSize:
                            screenWidth * 0.035, // Scales with screen width
                        color: Colors.black,
                        height: 1.7,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
  };

  return shapeWidgets[shape]?.call(post) ??
      Container(
        margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        child: InkWell(
          overlayColor: const WidgetStatePropertyAll(Colors.white),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => SingleServicesPage(
                      id: post.id,
                      id_reward: rewardID.toString(),
                      id_show: rewardID_show.toString(),
                    ),
              ),
            );
          },
          child: customSection_list(
            category:
                post.categories[0].name.isNotEmpty
                    ? post.categories[0].name
                    : '',
            subtitle: post.title,
            imageUrl: post.thumbnail ?? '',
            titleColor: Colors.black,
            subtitleColor: Colors.black,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => Archive(
                        rewardID: rewardID,
                        rewardID_show: rewardID_show,
                        box_article_mode: shapecategory,
                        id: post.categories[0].id,
                        name: post.categories[0].name,
                        title_show: true,
                        from_categories: true,
                      ),
                ),
              );
            },
            imageBorderColor: Colors.white,
          ),
        ),
      );
}

Widget getshapetags(
  BuildContext context,
  String? shape,
  ArchivePost post,
  shapetags,
  String? rewardID,
  String? rewardID_show,
) {
  double screenWidth = MediaQuery.of(context).size.width;
  double containerWidth = screenWidth * 0.9;
  double imageHeight = screenWidth * 0.35;
  double screenHeight = MediaQuery.of(context).size.height;
  final Map<String, Widget Function(ArchivePost post)> shapetagss = {
    "buildsection_archive":
        (post) => InkWell(
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => SingleServicesPage(
                        id: post.id,
                        id_reward: rewardID.toString(),
                        id_show: rewardID_show.toString(),
                      ),
                ),
              ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffe5eaef)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Image_style(
                    network: true,
                    height: screenHeight * 0.25,
                    width: double.infinity,
                    url: post.thumbnail ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 5),
                post.categories.isNotEmpty
                    ? InkWell(
                      overlayColor: const WidgetStatePropertyAll(
                        Colors.transparent,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => Archive(
                                  rewardID: rewardID,
                                  rewardID_show: rewardID_show,
                                  from_categories: true,
                                  name: post.categories[0].name,
                                  id: post.categories[0].id,
                                  title_show: true,
                                  box_article_mode: shape,
                                  onTab: () {
                                    Navigator.pop(context);
                                  },
                                ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xffc62326),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            post.categories[0].name,
                            style: GoogleFonts.alexandria(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                    : Container(),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: HtmlWidget(
                    post.title,
                    textStyle: GoogleFonts.alexandria(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    post.date,
                    style: GoogleFonts.alexandria(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
    "customSection_list":
        (post) => Container(
          margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          child: InkWell(
            overlayColor: const WidgetStatePropertyAll(Colors.white),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => SingleServicesPage(
                        id: post.id,
                        id_reward: rewardID.toString(),
                        id_show: rewardID_show.toString(),
                      ),
                ),
              );
            },
            child: customSection_list(
              category: post.categories[0].name,
              subtitle: post.title,
              imageUrl: post.thumbnail ?? '',
              titleColor: Colors.black,
              subtitleColor: Colors.black,

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => Archive(
                          rewardID: rewardID,
                          rewardID_show: rewardID_show,
                          box_article_mode: shapetags,
                          id: post.categories[0].id,
                          name: post.categories[0].name,
                          title_show: true,
                          from_categories: true,
                        ),
                  ),
                );
              },
              imageBorderColor: Colors.white,
            ),
          ),
        ),
    "buildsingleArtctile":
        (post) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
          child: SingleSection(
            rewardID: rewardID,
            rewardID_show: rewardID_show,
            shape: shape!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => SingleServicesPage(
                        id: post.id,
                        id_reward: rewardID.toString(),
                        id_show: rewardID_show.toString(),
                      ),
                ),
              );
            },
            Name: post.categories[0].name,
            idCategory: post.categories[0].id,
            imageUrl: post.thumbnail ?? '',
            category: post.categories[0].name,
            cleanTitle1: post.title,
            cleanContent: post.content,
          ),
        ),
    "buildsection_slider":
        (post) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => SingleServicesPage(
                          id: post.id,
                          id_reward: rewardID.toString(),
                          id_show: rewardID_show.toString(),
                        ),
                  ),
                );
              },
              child: Container(
                width: containerWidth,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffe5eaef)),
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.symmetric(
                  vertical: screenWidth * 0.01,
                  horizontal: screenWidth * 0.02,
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Image_style(
                              network: true,
                              url: post.thumbnail,
                              bottomLeft: 0,
                              topRight: 0,
                              topLeft: 0,
                              bottomRight: 0,
                              fit: BoxFit.contain,
                              height: imageHeight,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.02),
                      post.categories.isNotEmpty
                          ? InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => Archive(
                                        rewardID: rewardID,
                                        rewardID_show: rewardID_show,
                                        box_article_mode: shape,
                                        from_categories: true,
                                        id: post.categories.first.id,
                                        name: post.categories.first.name,
                                        title_show: true,
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: screenWidth * 0.004,
                                horizontal: screenWidth * 0.02,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xffc62326),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                post.categories.first.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.alexandria(
                                  fontSize: screenWidth * 0.025,
                                  color: Colors.white,
                                  height: 1.7,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          )
                          : Container(),
                      SizedBox(height: screenWidth * 0.01),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.alexandria(
                                fontSize: screenWidth * 0.03,
                                color: Colors.black,
                                height: 1.7,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: screenWidth * 0.01),
                            Wrap(
                              children: [
                                Text(
                                  post.content,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.alexandria(
                                    fontSize: screenWidth * 0.03,
                                    color: Colors.grey,
                                    height: 1.6,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
    "buildImageCarousel":
        (post) => InkWell(
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => SingleServicesPage(
                      id: post.id,
                      id_reward: rewardID.toString(),
                      id_show: rewardID_show.toString(),
                    ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffe5eaef)),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image_style(
                    network: true,
                    url: post.thumbnail,
                    bottomLeft: 0,
                    topRight: 0,
                    topLeft: 0,
                    bottomRight: 0,
                    fit: BoxFit.contain,
                    height: 100,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Wrap(
                          children: [
                            Text(
                              post.title,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.alexandria(
                                fontSize: 12.5,
                                color: Colors.black,
                                height: 1.7,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
  };

  return shapetagss[shape]?.call(post) ??
      Container(
        margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        child: InkWell(
          overlayColor: const WidgetStatePropertyAll(Colors.white),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => SingleServicesPage(
                      id: post.id,
                      id_reward: rewardID.toString(),
                      id_show: rewardID_show.toString(),
                    ),
              ),
            );
          },
          child: customSection_list(
            category: post.categories[0].name,
            subtitle: post.title,
            imageUrl: post.thumbnail ?? '',
            titleColor: Colors.black,
            subtitleColor: Colors.black,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => Archive(
                        rewardID: rewardID,
                        rewardID_show: rewardID_show,
                        box_article_mode: shapetags,
                        id: post.categories[0].id,
                        name: post.categories[0].name,
                        title_show: true,
                        from_categories: true,
                      ),
                ),
              );
            },
            imageBorderColor: Colors.white,
          ),
        ),
      );
}
