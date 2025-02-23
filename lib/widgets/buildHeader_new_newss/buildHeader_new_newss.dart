import 'package:flutter/material.dart';
import '../../@single/blade.dart';
import '../../Bloc/single_section/singel_section.dart';
import '../../Model/Home/home.dart';
import '../../screens/archive/archive.dart';
import '../../services/AdsContext/setup.dart';
import '../style_6/style_6.dart';
import '../style_8/style_8.dart';

Widget buildHeader_new_newss(
  List<Post> posts,
  String title,
  String shape,
  void Function()? onTap,
  PageController pagecontroller,
  BuildContext context,
  int currentpage,
  String bannerShow,
  String bannerID,
  String rewardID,
  String rewardID_show,
) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: recommendedSection(title, false, onTap),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleSection(
          rewardID: rewardID,
          rewardID_show: rewardID_show,
          shape: shape,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => SingleServicesPage(
                      id_reward: rewardID.toString(),
                      id_show: rewardID_show.toString(),

                      id: posts[0].id,
                    ),
              ),
            );
          },
          Name: posts[0].category.name,
          idCategory: posts[0].category.id,
          imageUrl: posts[0].thumbnail!,
          category: posts[0].category.name,
          cleanTitle1: posts[0].title,
          cleanContent: posts[0].content,
        ),
      ),
      const SizedBox(height: 10),
      ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: posts.length - 1,
        itemBuilder: (context, index) {
          final post = posts[index + 1];
          return InkWell(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
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
              margin: const EdgeInsets.only(bottom: 10),
              child: customSection_list(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => Archive(
                            rewardID: rewardID,
                            rewardID_show: rewardID_show,
                            box_article_mode: shape,
                            from_categories: true,
                            onTab: () {
                              Navigator.pop(context);
                            },
                            id: post.category.id,
                            name: post.category.name,
                            title_show: true,
                          ),
                    ),
                  );
                },
                category: post.category.name,
                subtitle: post.title,
                imageUrl: post.thumbnail!,
                titleColor: const Color(0xff607698),
                subtitleColor: Colors.black,
                rankColor: const Color(0xffC62326),
                imageBorderColor: Colors.red,
              ),
            ),
          );
        },
      ),
      const SizedBox(height: 10),
      bannerShow == "on"
          ? DynamicAdWidget(
            adUnitId: bannerID,
            // استبدل بـ Ad Unit ID الخاص بك
            adType: 'banner',
          )
          : Container(),
    ],
  );
}
