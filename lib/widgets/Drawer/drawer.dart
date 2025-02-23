import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../Constants/color.dart';
import '../../Model/Categories/categoris.dart';
import '../../Model/main/main.dart';
import '../../screens/archive/archive.dart';
import '../../screens/search/search.dart';
import '../../services/API/call.dart';
import '../app_bar/appBar.dart';

class CustomDrawer extends StatefulWidget {
  final void Function()? onTap;
  final String? shape;

  CustomDrawer({Key? key, required this.onTap, required this.shape})
    : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  List<Categoryy>? categories;
  bool isLoadingLogo = true;
  ScrollController main_scrollController = ScrollController();
  bool isLoadingMore = false;
  bool hasMoreData = true;
  bool isLoading = true;
  FetchMain? _fetchMainDataModel;

  int currentPage = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMainData();
    _fetchLogo();
    _loadCategories(page: currentPage);

    main_scrollController.addListener(() {
      if (main_scrollController.position.pixels ==
              main_scrollController.position.maxScrollExtent &&
          !isLoadingMore &&
          hasMoreData) {
        _loadCategories(page: currentPage + 1);
      }
    });
  }

  void _fetchLogo() async {
    try {
      if (mounted) {
        setState(() {
          isLoadingLogo = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingLogo = false;
        });
      }
    }
  }

  Future<void> _loadCategories({int page = 1, int perPage = 27}) async {
    if (isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          '${YourColorJson().baseUrl}/wp-json/wp/v2/categories',
        ).replace(
          queryParameters: {
            'page': page.toString(),
            'per_page': perPage.toString(),
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (!mounted) return;

        setState(() {
          if (page == 1) {
            categories = data.map((json) => Categoryy.fromJson(json)).toList();
          } else {
            categories!.addAll(
              data.map((json) => Categoryy.fromJson(json)).toList(),
            );
          }

          currentPage = page;
          hasMoreData = data.length == perPage;
        });
      } else {
        throw Exception('فشل تحميل البيانات');
      }
    } catch (e) {
      print('خطأ في تحميل البيانات: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  void dispose() {
    main_scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: double.infinity,
      backgroundColor: Colors.white,
      child: SafeArea(
        child:
            categories == null
                ? Center(
                  child: CircularProgressIndicator(color: Colorss().MainColor),
                )
                : _buildCategoryList(),
      ),
    );
  }

  Widget _buildCategoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomHeader(
          view: !isLoading,
          onTab_arrow: () => Navigator.pop(context),
          drawer: false,
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
                        bobox_article_mode:
                            _fetchMainDataModel
                                ?.archiveSearchOptions
                                .boxArticleMode ??
                            '',
                      ),
                ),
              ),
          isLoading: isLoadingLogo,
          scaffoldKey: _scaffoldKey,
          regionTextColor: Colors.white,
          locationTextColor: Colors.white,
        ),
        Expanded(
          child: ListView.builder(
            controller: main_scrollController,
            padding: const EdgeInsets.only(left: 15, right: 15),
            itemCount:
                (categories!.length / 3).ceil() + (isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == (categories!.length / 3).ceil()) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colorss().MainColor,
                    ),
                  ),
                );
              }

              int startIndex = index * 3;
              int endIndex = startIndex + 3;
              if (endIndex > categories!.length) {
                endIndex = categories!.length;
              }

              List<Categoryy> rowCategories = categories!.sublist(
                startIndex,
                endIndex,
              );

              bool isLastItemInColumn =
                  index == (categories!.length / 3).ceil() - 1;

              return Padding(
                padding: EdgeInsets.only(
                  bottom:
                      index == (categories!.length / 3).ceil() - 1 ? 10.0 : 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:
                      rowCategories
                          .asMap()
                          .entries
                          .map((entry) {
                            Categoryy category = entry.value;

                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                child: InkWell(
                                  overlayColor: const WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => Archive(
                                              rewardID:
                                                  _fetchMainDataModel!
                                                      .adsOptions
                                                      .RewardedId,
                                              rewardID_show:
                                                  _fetchMainDataModel!
                                                      .adsOptions
                                                      .enableRewardedAds,
                                              box_article_mode: widget.shape,
                                              from_categories: true,
                                              onTab: () {
                                                Navigator.pop(context);
                                              },
                                              title_show: true,
                                              id: category.id,
                                              name: category.name!,
                                            ),
                                      ),
                                    );
                                  },
                                  child: _buildMenuItem(
                                    category.name,
                                    startIndex,
                                    category.count,
                                    category.icon!,
                                    isLastItemInColumn,
                                  ),
                                ),
                              ),
                            );
                          })
                          .toList()
                          .expand(
                            (widget) => [widget, const SizedBox(width: 10)],
                          )
                          .toList()
                        ..removeLast(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    String? title,
    int index,
    int count,
    String icon,
    bool isLastItemInColumn,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: isLastItemInColumn ? 115 : 129,
          height: 129,
          padding: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            border: Border.all(color: const Color(0xffe5eaef)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 5),
              icon.isNotEmpty
                  ? SvgPicture.string(icon, width: 70, height: 50)
                  : Icon(
                    Icons.error_outline_outlined,
                    size: 30.0,
                    color: Colors.grey[400],
                  ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: Text(
                  title!,
                  maxLines: 1,
                  style: GoogleFonts.alexandria(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    color: Colorss().mainText_Color,
                  ),
                  textAlign: TextAlign.start,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                "( ${count} )",
                style: GoogleFonts.alexandria(
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ],
    );
  }
}
