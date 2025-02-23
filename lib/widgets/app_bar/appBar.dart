import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/main/main.dart';

class CustomHeader extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Color regionTextColor;
  final Color locationTextColor;
  final bool isLoading;
  final void Function()? search;
  final void Function()? onTab;
  final void Function()? onTab_arrow;
  final bool Icon_arrow;
  final bool drawer;
  final bool view;

  const CustomHeader({
    Key? key,
    required this.scaffoldKey,
    required this.regionTextColor,
    required this.locationTextColor,
    required this.isLoading,
    required this.search,
    required this.onTab,
    required this.Icon_arrow,
    required this.drawer,
    required this.onTab_arrow,
    this.view = false,
  }) : super(key: key);

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader>
    with TickerProviderStateMixin {
  bool isLoading = true;
  bool isLoadingLogo = true;
  String? error;
  FetchMain? _fetchMainDataModel; // Renamed variable to avoid conflict

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _loadData();
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('fetchMainData');
    String? lastUpdated = prefs.getString('lastUpdated');

    if (savedData != null && lastUpdated != null) {
      // التحقق مما إذا كانت البيانات قديمة (مثلاً تحديثها كل 24 ساعة)
      DateTime lastUpdateTime = DateTime.parse(lastUpdated);
      if (DateTime.now().difference(lastUpdateTime).inHours < 24) {
        setState(() {
          _fetchMainDataModel = FetchMain.fromJson(jsonDecode(savedData));
          isLoading = false;
        });
        _controller.forward();
        return; // لا داعي لاستدعاء API الآن
      }
    }

    // في حال عدم وجود بيانات أو إذا كانت قديمة، يتم جلبها من API
    _fetchMainData();
  }

  void _fetchMainData() async {
    try {
      final response = await http.post(
        Uri.parse('https://demo.elboshy.com/new_api/wp-json/app/v1/main'),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        // حفظ البيانات مع وقت آخر تحديث
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('fetchMainData', jsonEncode(jsonResponse));
        prefs.setString('lastUpdated', DateTime.now().toIso8601String());

        setState(() {
          _fetchMainDataModel = FetchMain.fromJson(jsonResponse);
          isLoading = false;
        });
        _controller.forward();
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

  @override
  Widget build(BuildContext context) {
    return _fetchMainDataModel?.topHeaderShowsIn == true &&
            _fetchMainDataModel?.topHeaderOptions.menuShowsIn == true &&
            _fetchMainDataModel?.topHeaderOptions.logoShowsIn == true &&
            _fetchMainDataModel?.topHeaderOptions.searchShowsIn == true
        ? widget.view == true
            ? Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Row(
                      children: [
                        widget.drawer == true
                            ? _fetchMainDataModel
                                        ?.topHeaderOptions
                                        .menuShowsIn ==
                                    true
                                ? InkWell(
                                  onTap: () {
                                    widget.scaffoldKey.currentState
                                        ?.openDrawer();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 3,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(height: 1.5),
                                        Container(
                                          width: 15,
                                          height: 2.5,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(height: 1.5),
                                        Column(
                                          children: [
                                            Container(
                                              width: 10,
                                              height: 2.5,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                : Container()
                            : InkWell(
                              overlayColor: const WidgetStatePropertyAll(
                                Colors.white,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: const Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                        InkWell(
                          onTap: widget.onTab,
                          child:
                              isLoading
                                  ? const SizedBox(
                                    width: 120,
                                    height: 0,
                                    child: Center(child: SizedBox.shrink()),
                                  )
                                  : _fetchMainDataModel == null ||
                                      _fetchMainDataModel!.logo.isEmpty
                                  ? const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 20,
                                  )
                                  : _fetchMainDataModel
                                          ?.topHeaderOptions
                                          .logoShowsIn ==
                                      true
                                  ? Image.network(
                                    _fetchMainDataModel!.logo,
                                    width: 120,
                                    loadingBuilder: (
                                      BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress,
                                    ) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return const SizedBox(
                                          width: 120,
                                          height: 0,
                                        );
                                      }
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: 20,
                                      );
                                    },
                                  )
                                  : Container(),
                        ),
                        const Spacer(),
                        const SizedBox(width: 15),
                        widget.Icon_arrow != true
                            ? _fetchMainDataModel
                                        ?.topHeaderOptions
                                        .searchShowsIn ==
                                    true
                                ? Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: InkWell(
                                    onTap: widget.search,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300]!.withOpacity(
                                          0.3,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        FontAwesomeIcons.search,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                                : Container()
                            : widget.drawer == true
                            ? InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300]!.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                            )
                            : Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: InkWell(
                                onTap: widget.search,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300]!.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    FontAwesomeIcons.search,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            )
            : Container()
        : Container();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
