// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../@single/blade.dart';
import '../../Bloc/Image_with_slider/Image&&slider.dart';
import '../../Model/Home/home.dart';
import '../../screens/archive/archive.dart';

class buildImageWithSliderr extends StatefulWidget {
  final List<Post> posts;
  String title;
  String? shape;

  buildImageWithSliderr({
    super.key,
    required this.posts,
    required this.title,
    required this.shape,
  });

  @override
  _ImageSliderWithDotsState createState() => _ImageSliderWithDotsState();
}

class _ImageSliderWithDotsState extends State<buildImageWithSliderr> {
  int currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.8, // تعديل هنا لزيادة عرض الصفحة النشطة
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            pageSnapping: true,
            padEnds: false,
            itemCount: widget.posts.length,
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: 15,
                  left: index == widget.posts.length - 1 ? 15 : 0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    children: [
                      Image.network(
                        widget.posts[index].thumbnail!,
                        // If thumbnail is null, an empty string will be passed to Image.network
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 350,
                        errorBuilder: (context, error, stackTrace) {
                          // If the image fails to load (e.g., URL is invalid or null), show the asset placeholder
                          return Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(minHeight: 300),
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey[500],
                              size: 50,
                            ),
                          );
                        },
                      ),
                      Positioned.fill(
                        child: containergradientcolor(
                          color1: Colors.black12.withValues(alpha: 1),
                          color12: Colors.transparent,
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      Positioned.fill(
                        child: InkWell(
                          overlayColor: const WidgetStatePropertyAll(
                            Colors.white,
                          ),
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => SingleServicesPage(
                                      id: widget.posts[index].id,
                                    ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                transform: const GradientRotation(8),
                                colors: [
                                  Colors.black12.withValues(alpha: 0.5),
                                  Colors.black12.withValues(alpha: 0),
                                  Colors.black12.withValues(alpha: 0),
                                  Colors.black12.withValues(alpha: 0),
                                  Colors.black12.withValues(alpha: 0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 30,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            texttitlefornews(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => Archive(
                                          box_article_mode: widget.shape,
                                          from_categories: true,
                                          onTab: () {
                                            Navigator.pop(context);
                                          },
                                          id: widget.posts[index].category.id,
                                          name:
                                              widget.posts[index].category.name,
                                          title_show: true,
                                        ),
                                  ),
                                );
                              },
                              colorcirclecontainer: const Color(0xffc62326),
                              text: widget.posts[index].category.name,
                              icon: Icons.arrow_forward_ios_outlined,
                              coloricon: const Color(0xffc62326),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            InkWell(
                              overlayColor: const WidgetStatePropertyAll(
                                Colors.white,
                              ),
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => SingleServicesPage(
                                          id: widget.posts[index].id,
                                        ),
                                  ),
                                );
                              },
                              child: Text(
                                widget.posts[index].title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.alexandria(
                                  shadows: [
                                    Shadow(
                                      color: Colors.black12.withValues(
                                        alpha: 0.8,
                                      ),
                                      offset: const Offset(0, 3),
                                      blurRadius: 3,
                                    ),
                                  ],
                                  fontSize: 16,
                                  height: 1.8,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.002),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
