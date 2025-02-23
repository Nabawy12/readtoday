// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, curly_braces_in_flow_control_structures

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photo_view/photo_view.dart';
import 'package:readtoday/widgets/style_6/style_6.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeletons/skeletons.dart';
import 'package:provider/provider.dart';
import '../Constants/color.dart';
import '../YC Style/Image.dart';
import '../provider/single.dart';
import '../screens/Home/home.dart';
import '../screens/archive/archive.dart';
import '../screens/search/search.dart';
import '../widgets/Drawer/drawer.dart';
import '../widgets/Single_services/single_services.dart';
import '../widgets/Sketlon/home/Single/single_services.dart';
import '../widgets/app_bar/appBar.dart';
import '../widgets/style_8/style_8.dart';

class SingleServicesPage extends StatefulWidget {
  final int id;
  final String id_reward;
  final String id_show;

  const SingleServicesPage({
    super.key,
    required this.id,
    required this.id_reward,
    required this.id_show,
  });

  @override
  _SingleServicesPageState createState() => _SingleServicesPageState();
}

class _SingleServicesPageState extends State<SingleServicesPage> {
  late SingleServicesProvider provider;
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;
  // Load the rewarded ad
  void _loadAndShowRewardedAd() {
    RewardedAd.load(
      adUnitId: widget.id_reward,
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

  @override
  void initState() {
    super.initState();
    widget.id_show == 'on' ? _loadAndShowRewardedAd() : null;
    _showRewardedAd();
    provider = SingleServicesProvider();
    provider.fetchPosts(widget.id, isRefresh: true);
    provider.positionsListener.itemPositions.addListener(() {
      provider.updateLastVisibleIndex();
      provider.checkScroll();
    });
    provider.fetchMainData();
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();

    provider.positionsListener.itemPositions.removeListener(() {
      provider.updateLastVisibleIndex();
      provider.checkScroll();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: Consumer<SingleServicesProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            floatingActionButton:
                provider.showFab == true
                    ? FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: () {
                        provider.scrollController.scrollTo(
                          index: 0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Icon(
                        Icons.arrow_upward,
                        color: Colorss().MainColor,
                      ),
                    )
                    : null,
            key: provider.scaffoldKey,
            drawer: CustomDrawer(
              onTap: () {},
              shape:
                  provider
                      .fetchMainDataModel
                      ?.archiveCategoryOptions
                      .boxArticleMode ??
                  '',
            ),
            backgroundColor: Colors.white,
            body:
                provider.isLoading && provider.isLoadingMore == true
                    ? const SafeArea(
                      child: Center(child: CustomContentSkeleton()),
                    )
                    : SafeArea(
                      child: Column(
                        children: [
                          CustomHeader(
                            view: true,
                            onTab_arrow: () {
                              Navigator.pop(context);
                            },
                            drawer: true,
                            Icon_arrow: true,
                            onTab: () {
                              provider.isLoading == true
                                  ? null
                                  : Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => Home(
                                            fetchMainDataModel:
                                                provider.fetchMainDataModel!,
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
                                              provider
                                                  .fetchMainDataModel!
                                                  .archiveSearchOptions
                                                  .boxArticleMode,
                                        ),
                                  ),
                                ),
                            isLoading: provider.canLoadMore,
                            scaffoldKey: provider.scaffoldKey,
                            regionTextColor: Colors.white,
                            locationTextColor: Colors.white,
                          ),
                          Expanded(
                            child: RefreshIndicator(
                              backgroundColor: Colors.white,
                              color: Colorss().MainColor,
                              onRefresh:
                                  () =>
                                      provider
                                          .refreshPostsFromLastVisibleIndex(),
                              child: ScrollablePositionedList.builder(
                                addAutomaticKeepAlives: true,
                                itemCount:
                                    provider.posts.length +
                                    (provider.canLoadMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == provider.posts.length) {
                                    return SafeArea(
                                      child: Center(
                                        child: Skeleton(
                                          isLoading: true,
                                          skeleton:
                                              const CustomContentSkeleton(),
                                          child: Container(),
                                        ),
                                      ),
                                    );
                                  }
                                  final post = provider.posts[index];

                                  // تحميل المزيد عند الوصول لآخر عنصر
                                  if (index == provider.posts.length - 1 &&
                                      provider.canLoadMore) {
                                    final nextPostId =
                                        post.customPostOptions.getNextPost.id;
                                    if (nextPostId != 0) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            provider.fetchPosts(nextPostId);
                                          });
                                    }
                                  }

                                  return Card(
                                    color: Colors.white,
                                    elevation: 0.0,
                                    shape: Border.all(
                                      color: Colors.white,
                                      strokeAlign: 0,
                                      width: 0,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 17,
                                      vertical: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        post
                                                .customPostOptions
                                                .category
                                                .isNotEmpty
                                            ? Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 4,
                                                    horizontal: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: Colors.black12,
                                                ),
                                              ),
                                              child: InkWell(
                                                overlayColor:
                                                    const WidgetStatePropertyAll(
                                                      Colors.white,
                                                    ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) => Archive(
                                                            box_article_mode:
                                                                provider
                                                                    .fetchMainDataModel
                                                                    ?.archiveCategoryOptions
                                                                    .boxArticleMode ??
                                                                '',
                                                            from_categories:
                                                                false,
                                                            id:
                                                                post
                                                                    .customPostOptions
                                                                    .category
                                                                    .first
                                                                    .id,
                                                            name:
                                                                post
                                                                    .customPostOptions
                                                                    .category
                                                                    .first
                                                                    .title,
                                                            title_show: true,
                                                          ),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  post
                                                      .customPostOptions
                                                      .category
                                                      .first
                                                      .title,
                                                  style: GoogleFonts.alexandria(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            )
                                            : Container(),
                                        const SizedBox(height: 20),
                                        post.title.rendered != ''
                                            ? HtmlWidget(
                                              post.title.rendered,
                                              textStyle: GoogleFonts.alexandria(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                            : Container(),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            // Share Icon - Disable when loading
                                            InkWell(
                                              hoverColor: Colors.transparent,
                                              splashColor: Colors.transparent,
                                              onTap: () {
                                                shareDynamicLink(post.id);
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  5,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.black12,
                                                  ),
                                                  color: const Color(
                                                    0xffC62326,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                ),
                                                child: const Icon(
                                                  Icons.share,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "شارك",
                                              style: GoogleFonts.alexandria(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const Spacer(),
                                            InkWell(
                                              overlayColor:
                                                  const WidgetStatePropertyAll(
                                                    Colors.white,
                                                  ),
                                              onTap: () {
                                                provider.launchWhatsApp();
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 5,
                                                    ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: Colors.black12,
                                                  ),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8.0,
                                                          ),
                                                      child: Text(
                                                        "تابعنا علي الواتس اب",
                                                        style:
                                                            GoogleFonts.alexandria(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors
                                                                      .grey
                                                                      .shade600,
                                                            ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            5,
                                                          ),
                                                      decoration:
                                                          const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                  Radius.circular(
                                                                    10,
                                                                  ),
                                                                ),
                                                            color: Color(
                                                              0xff3EAC1B,
                                                            ),
                                                          ),
                                                      child: const Icon(
                                                        FontAwesomeIcons
                                                            .whatsapp,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        SizedBox(
                                          height: 210,
                                          child: PageView.builder(
                                            physics:
                                                post
                                                            .customPostOptions
                                                            .videoId ==
                                                        "bottom"
                                                    ? const NeverScrollableScrollPhysics()
                                                    : const AlwaysScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            padEnds: false,
                                            pageSnapping: true,
                                            onPageChanged: (pageIndex) {
                                              provider.updateCurrentPage(
                                                pageIndex,
                                              );
                                            },
                                            itemCount:
                                                post
                                                            .customPostOptions
                                                            .videoId !=
                                                        "bottom"
                                                    ? 2
                                                    : 1,
                                            itemBuilder: (context, index) {
                                              if (index == 0) {
                                                return InkWell(
                                                  overlayColor:
                                                      const WidgetStatePropertyAll(
                                                        Colors.white,
                                                      ),
                                                  onTap: () {
                                                    post.featuredMediaUrl != ''
                                                        ? Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (
                                                                  context,
                                                                ) => FullScreenImagePage(
                                                                  imageUrl:
                                                                      post.featuredMediaUrl,
                                                                ),
                                                          ),
                                                        )
                                                        : null;
                                                  },
                                                  child: Image_style(
                                                    network: true,
                                                    height: 210,
                                                    topLeft: 0,
                                                    topRight: 0,
                                                    bottomLeft: 0,
                                                    bottomRight: 0,
                                                    url: post.featuredMediaUrl,
                                                    width: double.infinity,
                                                  ),
                                                );
                                              }
                                              if (post
                                                          .customPostOptions
                                                          .videoPosition !=
                                                      "bottom" &&
                                                  post
                                                          .customPostOptions
                                                          .videoId !=
                                                      '')
                                                if (index == 1 ||
                                                    post
                                                                .customPostOptions
                                                                .videoPosition !=
                                                            "bottom" &&
                                                        post
                                                                .customPostOptions
                                                                .videoId !=
                                                            '') {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          right: 5.0,
                                                          top: 0,
                                                          left: 0,
                                                          bottom: 0,
                                                        ),
                                                    child: VideoFrameWidget(
                                                      url:
                                                          "https://www.youtube.com/embed/${post.customPostOptions.videoId}",
                                                    ),
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              return null;
                                            },
                                          ),
                                        ),
                                        if (post
                                                .customPostOptions
                                                .videoPosition !=
                                            'bottom')
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: List.generate(2, (
                                                index,
                                              ) {
                                                return Container(
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 4.0,
                                                      ),
                                                  width:
                                                      provider.currentPage ==
                                                              index
                                                          ? 12.0
                                                          : 8.0,
                                                  height:
                                                      provider.currentPage ==
                                                              index
                                                          ? 12.0
                                                          : 8.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        provider.currentPage ==
                                                                index
                                                            ? Colorss()
                                                                .MainColor
                                                            : Colors.grey,
                                                    shape: BoxShape.circle,
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                        const SizedBox(height: 20),
                                        Wrap(
                                          spacing: 0, // Space between children
                                          runSpacing: 5, // Space between lines
                                          children: [
                                            Text(
                                              "نشر: ",
                                              style: GoogleFonts.alexandria(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              provider.formatDate(
                                                "${post.date}",
                                              ),
                                              style: GoogleFonts.alexandria(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        HtmlWidget(
                                          onLoadingBuilder: (
                                            context,
                                            element,
                                            loadingProgress,
                                          ) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: Colorss().MainColor,
                                                strokeWidth: 2.5,
                                              ),
                                            );
                                          },
                                          post.content.rendered,
                                          enableCaching: true,
                                          textStyle: GoogleFonts.alexandria(
                                            fontSize: 17,
                                            height: 1.8,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          customWidgetBuilder: (element) {
                                            if (element.localName == 'iframe') {
                                              final src =
                                                  element.attributes['src'] ??
                                                  "";
                                              return VideoFrameWidget(url: src);
                                            } else if (element.localName ==
                                                'img') {
                                              final src =
                                                  element.attributes['src'] ??
                                                  "";
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              FullScreenImagePage(
                                                                imageUrl: src,
                                                              ),
                                                    ),
                                                  );
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: CachedNetworkImage(
                                                    imageUrl: src,
                                                    placeholder:
                                                        (
                                                          context,
                                                          url,
                                                        ) => Center(
                                                          child: CircularProgressIndicator(
                                                            color:
                                                                Colorss()
                                                                    .MainColor,
                                                          ),
                                                        ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            const Icon(
                                                              Icons.error,
                                                            ),
                                                  ),
                                                ),
                                              );
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        post.customPostOptions.videoId != '' &&
                                                post
                                                        .customPostOptions
                                                        .videoPosition ==
                                                    'bottom'
                                            ? VideoFrameWidget(
                                              url:
                                                  "https://www.youtube.com/embed/${post.customPostOptions.videoId}",
                                            )
                                            : Container(),
                                        if (post
                                                    .customPostOptions
                                                    .postTag
                                                    .length >
                                                1 ||
                                            post.customPostOptions.postTag.any(
                                              (tag) =>
                                                  post
                                                      .customPostOptions
                                                      .postTag
                                                      .length >
                                                  1,
                                            ))
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "الكلمات الدلائلية",
                                                style: GoogleFonts.alexandria(
                                                  fontSize: 19,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Wrap(
                                                spacing: 5.0,
                                                runSpacing: 8.0,
                                                children:
                                                    post.customPostOptions.postTag.map((
                                                      tag,
                                                    ) {
                                                      return Container(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              5,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors
                                                              .grey[300]!
                                                              .withValues(
                                                                alpha: 0.7,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: InkWell(
                                                          overlayColor:
                                                              const WidgetStatePropertyAll(
                                                                Colors.white,
                                                              ),
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (
                                                                      context,
                                                                    ) => Archive(
                                                                      box_article_mode:
                                                                          provider
                                                                              .fetchMainDataModel
                                                                              ?.archivePostTagOptions
                                                                              .boxArticleMode,
                                                                      id: tag.id,
                                                                      name: '',
                                                                      title_show:
                                                                          true,
                                                                      from_categories:
                                                                          true,
                                                                    ),
                                                              ),
                                                            );
                                                          },
                                                          child: HtmlWidget(
                                                            "#${tag.title}",
                                                            textStyle:
                                                                GoogleFonts.alexandria(
                                                                  fontSize: 10,
                                                                  color:
                                                                      Colors
                                                                          .black,
                                                                ),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                              ),
                                              const SizedBox(height: 10),
                                            ],
                                          )
                                        else
                                          Container(),
                                        recommendedSection(
                                          "مقالات ذات صله",
                                          false,
                                          () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => Archive(
                                                      id:
                                                          post
                                                              .customPostOptions
                                                              .category
                                                              .first
                                                              .id,
                                                      name:
                                                          post
                                                              .customPostOptions
                                                              .category
                                                              .first
                                                              .title,
                                                      title_show: true,
                                                      from_categories: false,
                                                      box_article_mode:
                                                          provider
                                                              .fetchMainDataModel
                                                              ?.archiveCategoryOptions
                                                              .boxArticleMode ??
                                                          '',
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                        ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 0,
                                            horizontal: 0,
                                          ),
                                          shrinkWrap: true,
                                          itemCount: post.relatedPosts.length,
                                          itemBuilder: (context, index) {
                                            final postt =
                                                post.relatedPosts[index];
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 10.0,
                                              ),
                                              child: InkWell(
                                                overlayColor:
                                                    const WidgetStatePropertyAll(
                                                      Colors.white,
                                                    ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (
                                                            context,
                                                          ) => SingleServicesPage(
                                                            id_reward:
                                                                provider
                                                                    .fetchMainDataModel!
                                                                    .adsOptions
                                                                    .RewardedId,
                                                            id: postt.id,
                                                            id_show:
                                                                provider
                                                                    .fetchMainDataModel!
                                                                    .adsOptions
                                                                    .enableRewardedAds,
                                                          ),
                                                    ),
                                                  );
                                                },
                                                child: customSection_list(
                                                  category: postt.category.name,
                                                  subtitle: postt.content,
                                                  imageUrl: postt.thumbnail,
                                                  titleColor: Colors.black,
                                                  subtitleColor: Colors.black,
                                                  onTap: () {
                                                    if (kDebugMode) {
                                                      print(
                                                        "object1${provider.fetchMainDataModel?.archiveCategoryOptions.boxArticleMode}",
                                                      );
                                                    }
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (
                                                              context,
                                                            ) => Archive(
                                                              id: postt.id,
                                                              name: postt.title,
                                                              title_show: true,
                                                              from_categories:
                                                                  false,
                                                              descintion: true,
                                                              box_article_mode:
                                                                  provider
                                                                      .fetchMainDataModel
                                                                      ?.archiveCategoryOptions
                                                                      .boxArticleMode,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                  imageBorderColor:
                                                      Colors.white,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                itemScrollController: provider.scrollController,
                                itemPositionsListener:
                                    provider.positionsListener,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
          );
        },
      ),
    );
  }

  Future<Uri> createDynamicLink(int id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://readtodayy.page.link',
      // تحويل الـ id إلى String باستخدام toString()
      link: Uri.parse('https://yourapp.com/page?id=${id.toString()}'),

      androidParameters: AndroidParameters(
        packageName: 'com.examplee.readtoday',
        minimumVersion: 1,
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.examplee.readtoday',
        minimumVersion: '1.0.0',
      ),
    );

    final ShortDynamicLink shortDynamicLink = await FirebaseDynamicLinks
        .instance
        .buildShortLink(parameters);
    return shortDynamicLink.shortUrl;
  }

  void shareDynamicLink(int id) async {
    final Uri dynamicLink = await createDynamicLink(id);
    Share.share('$dynamicLinkتصفح هذا الرابط: ');
  }
}

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImagePage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Wrap your content in a GestureDetector
      body: GestureDetector(
        // You can use onVerticalDragUpdate to detect a downward swipe.
        // This example pops the page if the user drags down more than a threshold.
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 15) {
            // adjust the threshold as needed
            Navigator.pop(context);
          }
        },
        child: Center(
          child: PhotoView(
            wantKeepAlive: true,
            filterQuality: FilterQuality.high,
            loadingBuilder: (context, event) {
              return CircularProgressIndicator(
                color: Colorss().MainColor,
                strokeAlign: 1.2,
              );
            },
            imageProvider: CachedNetworkImageProvider(imageUrl),
          ),
        ),
      ),
    );
  }
}
