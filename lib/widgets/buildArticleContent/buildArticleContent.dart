import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../@single/blade.dart';
import '../../Bloc/single_section/singel_section.dart';
import '../../Model/Home/home.dart';
import '../../services/AdsContext/setup.dart';
import '../style_6/style_6.dart';

Widget buildArticleContent(
  List<Post> posts,
  BuildContext context,
  String title,
  String shape,
  void Function()? onTap,
) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 15),
    child: Column(
      children: [
        recommendedSection(title, false, onTap),
        SingleSection(
          shape: shape,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SingleServicesPage(id: posts.first.id),
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
        const SizedBox(height: 5),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          itemCount: posts.length - 1,
          itemBuilder: (context, index) {
            final post = posts[index + 1];
            return Container(
              padding: const EdgeInsets.all(7),
              margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffe5eaef)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                overlayColor: const WidgetStatePropertyAll(Colors.white),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SingleServicesPage(id: post.id),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.black,
                      size: 20,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 5,
                        ),
                        child: Text(
                          post.title,
                          style: GoogleFonts.alexandria(
                            color: Colors.black,
                            height: 1.7,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
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
        const SizedBox(height: 10),
        const DynamicAdWidget(
          adUnitId: 'ca-app-pub-3940256099942544/6300978111',
          adType: 'banner',
        ),
      ],
    ),
  );
}
