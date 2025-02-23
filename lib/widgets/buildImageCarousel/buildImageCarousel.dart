import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../@single/blade.dart';
import '../../YC Style/Image.dart';
import '../style_6/style_6.dart';

Widget buildImageCarousel(
  void Function()? onTap,
  List posts,
  PageController controller,
  String title,
  String rewardID,
  String rewardID_show,
) {
  return LayoutBuilder(
    builder: (context, constraints) {
      double screenWidth = constraints.maxWidth;
      double itemHeight = 185;
      double imageHeight = itemHeight * 0.6;
      double fontSize = screenWidth * 0.03;
      double padding = screenWidth * 0.03;

      return Column(
        mainAxisSize: MainAxisSize.min, // يمنع خطأ RenderBox
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: recommendedSection(title, false, onTap),
          ),
          SizedBox(
            height: itemHeight,
            child: PageView.builder(
              controller: controller,
              padEnds: false,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                EdgeInsets itemMargin =
                    index == 0
                        ? EdgeInsets.only(right: padding, left: padding / 2)
                        : EdgeInsets.symmetric(horizontal: padding / 2);

                return InkWell(
                  overlayColor: WidgetStatePropertyAll(Colors.transparent),
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
                      border: Border.all(color: Color(0xffe5eaef)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: itemMargin,
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image_style(
                            network: true,
                            url: post.thumbnail,
                            fit: BoxFit.contain,
                            height: imageHeight,
                            width: double.infinity,
                          ),
                          SizedBox(height: padding * 0.7),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              post.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.alexandria(
                                fontSize: fontSize,
                                color: Colors.black,
                                height: 1.7,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: padding * 0.6),
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
    },
  );
}
