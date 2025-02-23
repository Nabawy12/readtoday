import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../@single/blade.dart';
import '../../Model/Home/home.dart';
import '../../YC Style/Image.dart';
import '../../screens/archive/archive.dart';
import '../style_6/style_6.dart';

Widget buildImageCarousel_slider_details(void Function()? onTap,
    List<Post> posts, PageController controller, String title, String shape) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: recommendedSection(
          title,
          false,
          onTap,
        ),
      ),
      Container(
        height: 320,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: PageView.builder(
          reverse: false,
          controller: controller,
          padEnds: false,
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            EdgeInsets itemMargin;
            if (index == 0) {
              itemMargin = const EdgeInsets.only(right: 7, left: 5);
            } else {
              itemMargin = const EdgeInsets.symmetric(horizontal: 5);
            }

            return InkWell(
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SingleServicesPage(
                        id: post.id,
                      ),
                    ));
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xffe5eaef),
                    ),
                    borderRadius: BorderRadius.circular(20)),
                margin: itemMargin,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                const BoxShadow(
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
                                height: 140,
                                width: double.infinity,
                              ),
                            ),
                          )),
                      const SizedBox(
                        height: 12,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Archive(
                                    box_article_mode: shape,
                                    from_categories: true,
                                    id: post.category.id,
                                    name: post.category.name,
                                    title_show: true),
                              ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 10),
                          decoration: BoxDecoration(
                              color: const Color(0xffc62326),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            post.category.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.alexandria(
                                fontSize: 10,
                                color: Colors.white,
                                height: 1.7,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              post.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.alexandria(
                                  fontSize: 12.5,
                                  color: Colors.black,
                                  height: 1.7,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              post.content,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.alexandria(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  height: 1.6,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
