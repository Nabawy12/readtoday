import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../@single/blade.dart';
import '../../Constants/color.dart';
import '../../Model/Home/home.dart';

class BuildHeaderTopNews extends StatefulWidget {
  final List<Post> posts;
  final String title;
  final String rewardID;

  const BuildHeaderTopNews({
    required this.posts,
    required this.title,
    required this.rewardID,
  });

  @override
  _BuildHeaderTopNewsState createState() => _BuildHeaderTopNewsState();
}

class _BuildHeaderTopNewsState extends State<BuildHeaderTopNews> {
  late PageController _pageController;
  Timer? _scrollTimer;
  bool isScrolling = true;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.5,
    ); // Slight overlap between pages
    _startAutoScroll();
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));

      // Ensure the widget is still mounted before doing anything
      if (!mounted) return false;

      // Only animate to the next page if the widget is still mounted
      await _pageController.animateToPage(
        (_currentPage + 1) % widget.posts.length,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );

      // Ensure the widget is still mounted before calling setState()
      if (mounted) {
        setState(() {
          _currentPage = (_currentPage + 1) % widget.posts.length;
        });
      }

      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Icon(FontAwesomeIcons.fire, color: Colorss().MainColor),
        ),
        Expanded(
          child: AutoSliderTopNew(
            posts: widget.posts,
            pageController: _pageController,
          ),
        ),
      ],
    );
  }
}

class AutoSliderTopNew extends StatelessWidget {
  final List<Post> posts;
  final PageController pageController;
  final String? rewardID;
  final String? rewardID_show;

  const AutoSliderTopNew({
    required this.posts,
    required this.pageController,
    this.rewardID,
    this.rewardID_show,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: PageView.builder(
        reverse: false,
        controller: pageController,
        itemCount: posts.length,
        pageSnapping: false,
        padEnds: false,
        itemBuilder: (context, index) {
          return InkWell(
            overlayColor: const WidgetStatePropertyAll(Colors.white),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => SingleServicesPage(
                        id_reward: rewardID.toString(),
                        id: posts[index].id,
                        id_show: rewardID_show.toString(),
                      ),
                ),
              );
            },
            splashColor: Colorss().MainColor.withOpacity(0.2),
            highlightColor: Colorss().MainColor.withOpacity(0.1),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 8),
                  Icon(
                    FontAwesomeIcons.arrowTrendUp,
                    weight: 100,
                    size: 12,
                    color: Colorss().MainColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      posts[index].title,
                      textAlign: TextAlign.start,
                      softWrap: false,
                      style: GoogleFonts.alexandria(fontSize: 10, height: 1.6),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
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
}
