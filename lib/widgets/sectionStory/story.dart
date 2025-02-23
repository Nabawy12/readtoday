import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/color.dart';
import '../../Model/Home/home.dart';
import '../../screens/archive/archive.dart';
import '../style_6/style_6.dart';

class StoryListViewWidget extends StatelessWidget {
  final List<Post> posts;
  final String title;
  final String shape;
  final void Function()? onTap;

  const StoryListViewWidget({
    Key? key,
    required this.posts,
    required this.title,
    required this.shape,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // الحصول على عرض وارتفاع الشاشة
    final double fixedHeight =
        MediaQuery.of(context).size.height * 0.23; // مثال: 25% من ارتفاع الشاشة

    // نستخدم SizedBox لتحديد ارتفاع العنصر بالكامل
    return SizedBox(
      height: fixedHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final double height = constraints.maxHeight;

          // تحديد نسب أبعاد العناصر
          final double avatarRadius = width * 0.080;
          final double textContainerWidth = width * 0.20;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // العنوان مع Padding يعتمد على نسبة من العرض
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: recommendedSection(title, false, onTap),
              ),
              SizedBox(
                height: height * 0.6,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  scrollDirection: Axis.horizontal,
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.001),
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
                                    id: post.id,
                                    name: post.category.name,
                                    title_show: true,
                                    from_categories: true,
                                    box_article_mode: shape,
                                  ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(width * 0.0060),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colorss().MainColor,
                              ),
                              child: CircleAvatar(
                                radius: avatarRadius,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    (post.thumbnail != null &&
                                            post.thumbnail!.isNotEmpty)
                                        ? NetworkImage(post.thumbnail!)
                                        : null,
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            SizedBox(
                              width: textContainerWidth,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  post.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.alexandria(
                                    fontSize: width * 0.04,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
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
        },
      ),
    );
  }
}
