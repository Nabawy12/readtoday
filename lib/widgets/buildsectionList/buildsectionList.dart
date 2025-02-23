import 'package:flutter/material.dart';

import '../../@single/blade.dart';
import '../../Bloc/single_section/singel_section.dart';
import '../../Model/Home/home.dart';
import '../../screens/archive/archive.dart';
import '../style_6/style_6.dart';
import '../style_8/style_8.dart';

Widget buildsectionList(
  void Function()? onTap,
  List<Post> posts,
  String title,
  String shape,
  BuildContext context,
) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: recommendedSection(title, false, onTap),
      ),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleSection(
              shape: shape,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => SingleServicesPage(id: posts.first.id),
                  ),
                );
              },
              Name: posts.first.category.name,
              idCategory: posts.first.category.id,
              imageUrl: posts.first.thumbnail ?? '',
              category: posts.first.category.name,
              cleanTitle1: posts.first.title,
              cleanContent: posts.first.content,
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            primary: false,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
                      builder: (context) => SingleServicesPage(id: post.id),
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
                                box_article_mode: shape,
                                from_categories: true,
                                onTab: () {
                                  Navigator.pop(context);
                                },
                                id: post.category.id,
                                name: post.title,
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
        ],
      ),
    ],
  );
}
