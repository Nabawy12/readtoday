import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:skeletons/skeletons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../@single/blade.dart';
import '../../Bloc/single_section/singel_section.dart';
import '../../Model/Home/More.dart';
import '../../Model/Home/home.dart';
import '../../Model/main/main.dart';
import '../../YC Style/Image.dart';
import '../../services/API/call.dart';
import '../../widgets/Drawer/drawer.dart';
import '../../widgets/Fotter/fotter.dart';
import '../../widgets/Sketlon/Search/search.dart';
import '../../widgets/Sketlon/archive/archive.dart';
import '../../widgets/Sketlon/imageCusrssor/imagecurssor.dart';
import '../../widgets/Sketlon/story/story.dart';
import '../../widgets/app_bar/appBar.dart';
import '../../widgets/style_8/style_8.dart';
import '../archive/archive.dart';
import 'home.dart';

class More_Home extends StatefulWidget {
  final String WidgetID;
  final String per_page;
  final String page;
  final String? shapemore;
  final bool story;
  final String? rewardID_show;
  final String? rewardID;

  const More_Home({
    super.key,
    required this.WidgetID,
    required this.per_page,
    required this.page,
    this.story = false,
    this.shapemore,
    required this.rewardID_show,
    required this.rewardID,
  });

  @override
  State<More_Home> createState() => _More_HomeState();
}

class _More_HomeState extends State<More_Home> {
  late Future<Post> futureData;
  late ScrollController _scrollController;
  int currentPage = 2;
  List<MoreHomePost> posts = [];
  bool _isLoading = false;
  bool isLoading = true;
  String? error;
  MoreHome? moreHome;
  FetchMain? _fetchMainDataModel;
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    widget.rewardID_show == "on" ? _loadAndShowRewardedAd() : null;
    currentPage = int.parse(
      widget.page,
    ); // Initialize the page from the passed argument
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    fetchAllData();
    _fetchMainData();
  }

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

  void _fetchMainData() async {
    try {
      final response = await http.post(
        Uri.parse('${YourColorJson().baseUrl}/wp-json/app/v1/main'),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        setState(() {
          _fetchMainDataModel = FetchMain.fromJson(jsonResponse);
          isLoading = false;
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

  void fetchAllData() async {
    if (widget.story != false) {
      await fetchData(widget.WidgetID, "30", widget.page);
      await fetchData(widget.WidgetID, widget.per_page, "2");
      await fetchData(widget.WidgetID, widget.per_page, "3");
      await fetchData(widget.WidgetID, widget.per_page, "4");
      await fetchData(widget.WidgetID, widget.per_page, "5");

      if (mounted) {
        setState(() {
          currentPage = 5;
        });
      }
    } else {
      await fetchData(widget.WidgetID, widget.per_page, widget.page);
    }
  }

  Future<void> fetchData(String widgetID, String perPage, String page) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    final url =
        '${YourColorJson().baseUrl}/wp-json/app/v1/home/HomeWadgits/?WidgetID=$widgetID&per_page=$perPage&Paged=$page';

    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        moreHome = MoreHome.fromJson(decodedData);

        setState(() {
          posts.addAll(moreHome!.posts);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        moreHome!.queryCount > posts.length) {
      setState(() {
        currentPage++;
      });
      fetchData(
        widget.WidgetID,
        widget.per_page,
        moreHome!.nextPaged.toString(),
      );
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(
        onTap: () {},
        shape: _fetchMainDataModel?.archiveCategoryOptions.boxArticleMode,
      ),
      drawerEnableOpenDragGesture:
          _fetchMainDataModel?.topHeaderOptions.menuShowsIn == true
              ? true
              : false,
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          if (_scaffoldKey.currentState!.isDrawerOpen) {
            Navigator.pop(context);
            return false;
          } else
            Navigator.pop(context);
          return true;
        },
        child: RefreshIndicator(
          color: const Color(0xffC62326),
          backgroundColor: Colors.white,
          onRefresh: () async {
            posts.clear();
            moreHome!.posts.clear();
            if (widget.story != false) {
              await fetchData(widget.WidgetID, "30", widget.page);
              await fetchData(widget.WidgetID, widget.per_page, "2");
              await fetchData(widget.WidgetID, widget.per_page, "3");
              await fetchData(widget.WidgetID, widget.per_page, "4");
              await fetchData(widget.WidgetID, widget.per_page, "5");

              setState(() {
                currentPage = 5;
              });
            } else {
              await fetchData(widget.WidgetID, widget.per_page, widget.page);
              setState(() {
                currentPage = 2;
              });
            }
          },
          child: SafeArea(
            top: true,
            bottom: false,
            right: false,
            left: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeader(
                  view: true,
                  onTab_arrow: () => Navigator.pop(context),
                  drawer: true,
                  Icon_arrow: true,
                  onTab: () {
                    isLoading == true
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
                  search: () => Navigator.pop(context),
                  isLoading: false,
                  scaffoldKey: _scaffoldKey,
                  regionTextColor: Colors.white,
                  locationTextColor: Colors.white,
                ),

                Expanded(
                  child:
                      posts.isEmpty
                          ? widget.story != false
                              ? GridSkeletonPost(
                                isLoading: _isLoading,
                                count: 100,
                              )
                              : widget.shapemore == 'customSection_list'
                              ? Padding(
                                padding: const EdgeInsets.only(),
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  shrinkWrap: true,
                                  itemCount: 10,
                                  itemBuilder: (context, index) {
                                    return customSectionSkeleton();
                                  },
                                ),
                              )
                              : widget.shapemore == 'buildsection_slider' ||
                                  widget.shapemore == 'buildImageCarousel'
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
                              )
                          : Column(
                            children: [
                              moreHome!.archiveOptions.boxArticleMode !=
                                          "buildsection_slider" &&
                                      moreHome!.archiveOptions.boxArticleMode !=
                                          "buildImageCarousel" &&
                                      widget.story != true
                                  ? Expanded(
                                    child: ListView.builder(
                                      controller: _scrollController,
                                      itemCount:
                                          posts.length + (_isLoading ? 2 : 1),
                                      itemBuilder: (context, index) {
                                        if (index ==
                                            posts.length +
                                                (_isLoading ? 1 : 0)) {
                                          return Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                footer(
                                                  image:
                                                      _fetchMainDataModel!.logo,
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
                                        }
                                        if (index == posts.length &&
                                            _isLoading) {
                                          return Center(
                                            child:
                                                widget.shapemore ==
                                                        'customSection_list'
                                                    ? ListView.builder(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 15,
                                                          ),

                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: 10,
                                                      itemBuilder: (
                                                        context,
                                                        index,
                                                      ) {
                                                        return customSectionSkeleton();
                                                      },
                                                    )
                                                    : widget.shapemore ==
                                                            'buildsection_slider' ||
                                                        widget.shapemore ==
                                                            'buildImageCarousel'
                                                    ? SkeletonGrid()
                                                    : Skeleton_archive(),
                                          );
                                        }

                                        final post = posts[index];
                                        print(widget.shapemore);
                                        return getShapeWidget(
                                          context,
                                          moreHome!
                                              .archiveOptions
                                              .boxArticleMode,
                                          post,
                                          _fetchMainDataModel
                                                  ?.archiveCategoryOptions
                                                  .boxArticleMode ??
                                              '',
                                          _fetchMainDataModel!
                                              .adsOptions
                                              .RewardedId,
                                          _fetchMainDataModel!
                                              .adsOptions
                                              .enableRewardedAds,
                                        );
                                      },
                                    ),
                                  )
                                  : Expanded(
                                    child: GridView.builder(
                                      controller: _scrollController,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 13,
                                        vertical: 10,
                                      ),
                                      primary: false,
                                      shrinkWrap: true,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: _getGridColumns(
                                              context,
                                            ),
                                            crossAxisSpacing: 0,
                                            mainAxisSpacing: 5,
                                            childAspectRatio:
                                                _getChildAspectRatio(context),
                                          ),
                                      itemCount:
                                          posts.length +
                                          (_isLoading
                                              ? widget.story != true
                                                  ? 4
                                                  : 5
                                              : 0),
                                      itemBuilder: (context, index) {
                                        if (_isLoading &&
                                            index >= posts.length) {
                                          return widget.story != true
                                              ? widget.shapemore ==
                                                      'customSection_list'
                                                  ? Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 15,
                                                        ),

                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: 10,
                                                      itemBuilder: (
                                                        context,
                                                        index,
                                                      ) {
                                                        return customSectionSkeleton();
                                                      },
                                                    ),
                                                  )
                                                  : widget.shapemore ==
                                                          'buildsection_slider' ||
                                                      widget.shapemore ==
                                                          'buildImageCarousel'
                                                  ? SkeletonServiceCard()
                                                  : Skeleton_archive()
                                              : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                    ),
                                                child: SkeletonAvatar(
                                                  style: SkeletonAvatarStyle(
                                                    shape: BoxShape.circle,
                                                    width: 54,
                                                    height: 54,
                                                  ),
                                                ),
                                              );
                                        }
                                        final post = posts[index];
                                        if (widget.story != true) {
                                          return getShapeWidget(
                                            context,
                                            moreHome!
                                                .archiveOptions
                                                .boxArticleMode,
                                            post,
                                            _fetchMainDataModel
                                                    ?.archiveCategoryOptions
                                                    .boxArticleMode ??
                                                '',
                                            _fetchMainDataModel!
                                                .adsOptions
                                                .RewardedId,
                                            _fetchMainDataModel!
                                                .adsOptions
                                                .enableRewardedAds,
                                          );
                                        } else {
                                          return SizedBox(
                                            height: 147,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 5.0,
                                                      ),
                                                  child: InkWell(
                                                    overlayColor:
                                                        const WidgetStatePropertyAll(
                                                          Colors.transparent,
                                                        ),
                                                    splashColor: Colors.white,
                                                    hoverColor: Colors.white,
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (
                                                                context,
                                                              ) => Archive(
                                                                rewardID:
                                                                    _fetchMainDataModel!
                                                                        .adsOptions
                                                                        .RewardedId,
                                                                rewardID_show:
                                                                    _fetchMainDataModel!
                                                                        .adsOptions
                                                                        .enableRewardedAds,
                                                                box_article_mode:
                                                                    _fetchMainDataModel!
                                                                        .archiveCategoryOptions
                                                                        .boxArticleMode,
                                                                from_categories:
                                                                    true,
                                                                id: post.id,
                                                                name:
                                                                    post.title,
                                                                title_show:
                                                                    true,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                2,
                                                              ),
                                                          decoration:
                                                              const BoxDecoration(
                                                                shape:
                                                                    BoxShape
                                                                        .circle,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                Colors
                                                                    .grey[300],
                                                            backgroundImage:
                                                                post.thumbnail !=
                                                                        null
                                                                    ? CachedNetworkImageProvider(
                                                                      post.thumbnail ??
                                                                          '',
                                                                    )
                                                                    : null,
                                                            radius: 27,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 3,
                                                        ),
                                                        Text(
                                                          post.title,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          maxLines: 1,
                                                          style:
                                                              GoogleFonts.alexandria(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                            ],
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _getChildAspectRatio(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (width >= 1200) {
      if (widget.story == true) {
        return 0.8;
      } else
        return 0.8; // For large screens
    } else if (width >= 800) {
      if (widget.story == true) {
        return 0.8;
      } else
        return 0.7; // For medium screens
    } else {
      if (widget.story == true) {
        return 0.8;
      } else
        return 0.6;
    }
  }

  /// Get the number of columns based on screen size
  int _getGridColumns(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (width >= 1200) {
      return 5; // Large screens (e.g., tablets, desktops)
    } else if (width >= 800) {
      return 3; // Medium screens (e.g., larger phones, small tablets)
    } else {
      if (widget.story == true) {
        return 5;
      } else
        return 2; // Small screens (e.g., phones)
    }
  }
}

Widget getShapeWidget(
  BuildContext context,
  String? shape,
  MoreHomePost post,
  String archive_shape,
  String? rewardID,
  String? rewardID_show,
) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  double containerWidth = screenWidth * 0.9;
  double imageHeight = screenWidth * 0.35;
  final Map<String, Widget Function(MoreHomePost post)> shapeWidgets = {
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
                post.category.id != 0 && post.category.title.isNotEmpty
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
                                  name: post.category.title,
                                  id: post.category.id,
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
                            post.category.title,
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
                        id_reward: rewardID.toString(),
                        id_show: rewardID_show.toString(),

                        id: post.id,
                      ),
                ),
              );
            },
            child: customSection_list(
              category: post.category.title,
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
                          box_article_mode: archive_shape,
                          id: post.category.id,
                          name: post.category.title,
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
                        id_reward: rewardID.toString(),
                        id_show: rewardID_show.toString(),

                        id: post.id,
                      ),
                ),
              );
            },
            Name: post.category.title,
            idCategory: post.category.id,
            imageUrl: post.thumbnail ?? '',
            category: post.category.title,
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
                          id_reward: rewardID.toString(),
                          id_show: rewardID_show.toString(),

                          id: post.id,
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
                  vertical: screenWidth * 0.00,
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
                      post.category.id != 0 && post.category.title != ''
                          ? InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => Archive(
                                        rewardID: rewardID,
                                        rewardID_show: rewardID_show,
                                        box_article_mode: archive_shape,
                                        from_categories: true,
                                        id: post.category.id,
                                        name: post.category.title,
                                        title_show: true,
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: screenWidth * 0.01,
                                horizontal: screenWidth * 0.02,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xffc62326),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                post.category.title,
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
                      id_reward: rewardID.toString(),
                      id_show: rewardID_show.toString(),

                      id: post.id,
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
                      id_reward: rewardID.toString(),
                      id_show: rewardID_show.toString(),

                      id: post.id,
                    ),
              ),
            );
          },
          child: customSection_list(
            category: post.category.title,
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
                        box_article_mode: archive_shape,
                        id: post.category.id,
                        name: post.category.title,
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
