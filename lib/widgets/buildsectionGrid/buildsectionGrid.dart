import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../@single/blade.dart';
import '../../Model/Home/home.dart';
import '../../YC Style/Image.dart';
import '../../screens/archive/archive.dart';
import '../style_6/style_6.dart';

Widget buildsectionGrid(
  List<Post> posts,
  String title,
  String shape,
  void Function()? onTap,
  BuildContext context,
  String? rewardID,
  String rewardID_show,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: recommendedSection(title, false, onTap),
      ),
      Wrap(
        spacing: 10, // Horizontal space between items
        runSpacing: 0, // Vertical space between items
        alignment: WrapAlignment.start,
        children: List.generate(posts.length, (index) {
          final post = posts[index];
          final category =
              post.category != null ? post.category.name : "No Category";

          return Container(
            width: (MediaQuery.of(context).size.width - 13 * 1 - 20) / 2,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffe5eaef)),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                _buildGridItem(
                  imageUrl: post.thumbnail ?? '',
                  category: category,
                  onTap_category:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => Archive(
                                box_article_mode: shape,
                                from_categories: true,
                                id: post.category.id,
                                name: post.category.name,
                                title_show: true,
                              ),
                        ),
                      ),
                  title: post.title,
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
                ),
              ],
            ),
          );
        }),
      ),
    ],
  );
}

Widget _buildGridItem({
  required String imageUrl,
  required String category,
  required String title,
  required Function() onTap,
  required Function() onTap_category,
}) {
  return SizedBox(
    height: 200,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Image_style(
            network: true,
            bottomRight: 0,
            bottomLeft: 0,
            topRight: 0,
            topLeft: 0,
            url: imageUrl ?? '',
            width: double.infinity,
            height: 120,
          ),
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: onTap_category,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            decoration: BoxDecoration(
              color: Color(0xffc62326),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              category,
              maxLines: 1,
              style: GoogleFonts.alexandria(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.7,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: onTap,
          child: Text(
            title,
            maxLines: 2,
            style: GoogleFonts.alexandria(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: Colors.black,
              height: 1.7,
            ),
          ),
        ),
      ],
    ),
  );
}
