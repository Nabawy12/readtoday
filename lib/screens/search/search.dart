import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gif/gif.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../@single/blade.dart';
import '../../Bloc/single_section/singel_section.dart';
import '../../Model/main/main.dart';
import '../../Model/search/search.dart';
import '../../YC Style/Image.dart';
import '../../widgets/Drawer/drawer.dart';
import '../../widgets/Sketlon/Search/search.dart';
import '../../widgets/Sketlon/archive/archive.dart';
import '../../widgets/Sketlon/imageCusrssor/imagecurssor.dart';
import '../../widgets/app_bar/appBar.dart';
import '../../widgets/style_8/style_8.dart';
import '../archive/archive.dart';

class Search extends StatefulWidget {
  final String bobox_article_mode;

  const Search({super.key, required this.bobox_article_mode});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String? error;
  bool isInitialLoading = true;
  bool hasMorePosts = true;
  int currentOffset = 0;
  bool _isLoadingMore = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController main_scrollController = ScrollController();
  late Future<Map<String, dynamic>> widgets;
  bool floatingbutton = false;
  bool isInternetConnected = true;
  SearchModel? searchResult;
  int currentPaged = 1;
  FetchMain? _fetchMainDataModel;

  final TextEditingController _searchController = TextEditingController();

  List<PostSearch> _allSearchResults = [];

  bool _isLoading = false;

  String errorMessage = '';

  void scrollToTop() {
    main_scrollController.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void _fetchMainData() async {
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
          _isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load data';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Failed to load data';
          _isLoading = false;
        });
      }
    }
  }

  void _scrollListener() {
    // Check if we have scrolled to the bottom
    if (main_scrollController.position.pixels ==
        main_scrollController.position.maxScrollExtent) {
      if (_isLoading || _isLoadingMore || !hasMorePosts) {
        return; // Prevent loading more if already loading or no more posts
      }

      currentPaged++; // Increment the current page
      setState(() {
        _isLoadingMore = true; // Set loading more state
      });
      _performSearch(); // Fetch new data for the next page
    }
  }

  Future<void> _performSearch() async {
    String normalizedSearchQuery = _searchController.text.trim();
    if (normalizedSearchQuery.isEmpty) {
      if (mounted) {
        setState(() {
          errorMessage = 'Please enter some text to search.';
          _isLoading = false;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = currentPaged == 1; // Start loading on first page
        _isLoadingMore =
            currentPaged > 1; // Set loading more state after page 1
        errorMessage = '';
        if (currentPaged == 1) {
          _allSearchResults.clear(); // Clear old data if it's the first page
        }
      });
    }

    try {
      // Construct the URL with the current page parameter
      final url =
          'https://demo.elboshy.com/new_api/wp-json/app/v1/get_objects?Paged=$currentPaged&object_type=posts&object_name=post&search=$normalizedSearchQuery';

      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        searchResult = SearchModel.fromJson(data);

        if (mounted) {
          setState(() {
            // Add the new search results to the existing list
            _allSearchResults.addAll(searchResult?.postsSearch ?? []);
            hasMorePosts = searchResult?.postsSearch.isNotEmpty ?? false;
            _isLoading = false; // Stop loading once data is fetched
            _isLoadingMore =
                false; // Stop loading more once new data is fetched
          });
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = 'Error during search: ${response.statusCode}';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Error during search: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMainData();
    main_scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    main_scrollController.dispose();
    main_scrollController.removeListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: CustomDrawer(
        shape: _fetchMainDataModel?.archiveCategoryOptions.boxArticleMode,
        onTap: () {},
      ),
      body: SafeArea(
        right: false,
        left: false,
        child: Column(
          children: [
            CustomHeader(
              view: true,
              onTab_arrow: () => Navigator.pop(context),
              drawer: true,
              Icon_arrow: true,
              onTab: () {
                Navigator.pop(context);
              },
              search:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => Search(
                            bobox_article_mode: widget.bobox_article_mode,
                          ),
                    ),
                  ),
              isLoading: _isLoading,
              scaffoldKey: _scaffoldKey,
              regionTextColor: Colors.white,
              locationTextColor: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              child: TextField(
                focusNode: FocusNode(),
                autofocus: true,
                enableInteractiveSelection: false,
                controller: _searchController,
                cursorColor: Colors.black,
                style: GoogleFonts.alexandria(fontSize: 12),
                onChanged: (value) {
                  if (value.length >= 3) {
                    setState(() {
                      _isLoading = true; // Start loading when searching
                    });
                    _performSearch();
                  }
                },
                decoration: InputDecoration(
                  focusColor: Colors.black12,
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                  disabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                  hintText: 'بحث',
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, size: 20),
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      _allSearchResults.clear();
                      _performSearch();
                    },
                  ),
                ),
                onSubmitted: (value) {
                  if (value.length >= 3) {
                    setState(() {
                      _isLoading = true;
                    });
                    _allSearchResults.clear();

                    _performSearch();
                  }
                },
              ),
            ),
            const SizedBox(height: 5),
            // Check if search query is empty and show GIF
            if (_searchController.text.isEmpty && !_isLoading)
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Gif(
                    autostart: Autostart.once,
                    image: const AssetImage('assets/images/Search.gif'),
                  ),
                ),
              )
            // If loading, show loading skeleton
            else if (_isLoading)
              Expanded(
                child:
                    widget.bobox_article_mode == 'customSection_list'
                        ? Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return customSectionSkeleton();
                            },
                          ),
                        )
                        : widget.bobox_article_mode == 'buildsection_slider' ||
                            widget.bobox_article_mode == 'buildImageCarousel'
                        ? SkeletonGrid()
                        : Skeleton_archive(),
              )
            else if (_allSearchResults.isEmpty && !_isLoading)
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Gif(
                    autostart: Autostart.once,
                    image: const AssetImage('assets/images/Search.gif'),
                  ),
                ),
              )
            else
              Expanded(
                child:
                    widget.bobox_article_mode != "buildsection_slider" &&
                            widget.bobox_article_mode != "buildImageCarousel"
                        ? ListView.builder(
                          controller: main_scrollController,
                          itemCount:
                              _allSearchResults.length +
                              (_isLoadingMore
                                  ? 1
                                  : 0), // Add one for the loading indicator
                          padding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 10,
                          ),
                          itemBuilder: (context, index) {
                            if (_isLoadingMore &&
                                index == _allSearchResults.length) {
                              return Center(
                                child:
                                    widget.bobox_article_mode ==
                                            'customSection_list'
                                        ? Padding(
                                          padding: const EdgeInsets.only(
                                            top: 0,
                                          ),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: 10,
                                            itemBuilder: (context, index) {
                                              return customSectionSkeleton();
                                            },
                                          ),
                                        )
                                        : widget.bobox_article_mode ==
                                                'buildsection_slider' ||
                                            widget.bobox_article_mode ==
                                                'buildImageCarousel'
                                        ? const SkeletonServiceCard()
                                        : Skeleton_archive(),
                              );
                            }

                            final post =
                                _allSearchResults[index]; // Access the posts

                            // Check if the categorySearch list is not empty
                            if (post.categorySearch.isNotEmpty) {
                              return getShapesearch(
                                context,
                                widget.bobox_article_mode,
                                post,
                                _fetchMainDataModel
                                        ?.archiveCategoryOptions
                                        .boxArticleMode ??
                                    '',
                                _fetchMainDataModel!.adsOptions.RewardedId,
                                _fetchMainDataModel!
                                    .adsOptions
                                    .enableRewardedAds,
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        )
                        : GridView.builder(
                          controller: main_scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 13),
                          primary: false,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    widget.bobox_article_mode ==
                                                'buildsection_slider' ||
                                            widget.bobox_article_mode ==
                                                'buildImageCarousel'
                                        ? 2
                                        : 5,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0,
                                childAspectRatio:
                                    widget.bobox_article_mode !=
                                            "buildsection_slider"
                                        ? 0.8
                                        : 0.5,
                              ),
                          itemCount:
                              _allSearchResults.length +
                              (_isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (_isLoadingMore &&
                                index == _allSearchResults.length) {
                              return Center(
                                child:
                                    widget.bobox_article_mode ==
                                            'customSection_list'
                                        ? Padding(
                                          padding: const EdgeInsets.only(
                                            top: 0,
                                          ),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: 10,
                                            itemBuilder: (context, index) {
                                              return customSectionSkeleton();
                                            },
                                          ),
                                        )
                                        : widget.bobox_article_mode ==
                                                'buildsection_slider' ||
                                            widget.bobox_article_mode ==
                                                'buildImageCarousel'
                                        ? const SkeletonServiceCard()
                                        : Skeleton_archive(),
                              );
                            }

                            final post = _allSearchResults[index];
                            return getShapesearch(
                              context,
                              widget.bobox_article_mode,
                              post,
                              _fetchMainDataModel!
                                  .archiveCategoryOptions
                                  .boxArticleMode,
                              _fetchMainDataModel!.adsOptions.RewardedId,
                              _fetchMainDataModel!.adsOptions.enableRewardedAds,
                            );
                          },
                        ),
              ),
          ],
        ),
      ),
    );
  }
}

Widget getShapesearch(
  BuildContext context,
  String? shape,
  PostSearch post,
  String archiveShape,
  String rewardID,
  String rewardID_show,
) {
  double screenWidth = MediaQuery.of(context).size.width;
  double containerWidth = screenWidth * 0.9;
  double imageHeight = screenWidth * 0.35;
  double screenHeight = MediaQuery.of(context).size.height;
  final Map<String, Widget Function(PostSearch post)> shapeWidgets = {
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
                        id_reward: rewardID.toString(),
                        id: post.id,
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
                    url: post.thumbnail,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 5),
                InkWell(
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
                              name: post.categorySearch[0].name,
                              id: post.categorySearch[0].id,
                              title_show: true,
                              box_article_mode: archiveShape,
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
                        post.categorySearch[0].name,
                        style: GoogleFonts.alexandria(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
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
          margin: const EdgeInsets.only(bottom: 10),
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
              category: post.categorySearch[0].name,
              subtitle: post.title,
              imageUrl: post.thumbnail,
              titleColor: Colors.black,
              subtitleColor: Colors.black,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => Archive(
                          box_article_mode: archiveShape,
                          id: post.categorySearch[0].id,
                          name: post.categorySearch[0].name,
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
            Name: post.categorySearch[0].name,
            idCategory: post.categorySearch[0].id,
            imageUrl: post.thumbnail,
            category: post.categorySearch[0].name,
            cleanTitle1: post.title,
            cleanContent: post.content,
          ),
        ),
    "buildsection_slider":
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
            width: containerWidth,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffe5eaef)),
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02,
              vertical: screenWidth * 0.02,
            ),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
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
                  SizedBox(height: screenWidth * 0.03),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => Archive(
                                box_article_mode: archiveShape,
                                from_categories: true,
                                id: post.categorySearch.first.id,
                                name: post.categorySearch.first.name,
                                title_show: true,
                              ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: screenWidth * 0.005,
                        horizontal: screenWidth * 0.02,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffc62326),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        post.categorySearch.first.name,
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
                  ),
                  SizedBox(height: screenWidth * 0.02),
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
                        SizedBox(height: screenWidth * 0.02),
                        Wrap(
                          children: [
                            Text(
                              post.content,
                              maxLines: 5,
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
            category: post.categorySearch[0].name,
            subtitle: post.title,
            imageUrl: post.thumbnail,
            titleColor: Colors.black,
            subtitleColor: Colors.black,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => Archive(
                        box_article_mode: archiveShape,
                        id: post.categorySearch[0].id,
                        name: post.categorySearch[0].name,
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
