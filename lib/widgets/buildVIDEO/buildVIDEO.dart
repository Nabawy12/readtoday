import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../@single/blade.dart';
import '../../Model/Home/home.dart';
import '../../YC Style/Image.dart';
import '../style_6/style_6.dart';

Widget buildVIDEO(List<Post> posts, String title, void Function()? onTap) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0),
        child: recommendedSection(title, false, onTap),
      ),
      Container(
        alignment: Alignment.center,
        height: 280,
        decoration: const BoxDecoration(color: Color(0xff141e28)),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                scrollDirection: Axis.horizontal,
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    overlayColor: const WidgetStatePropertyAll(
                      Colors.transparent,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  SingleServicesPage(id: posts[index].id),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7.0,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Image_style(
                                network: true,
                                width: 200,
                                height: 120,
                                url: posts[index].thumbnail,
                                bottomLeft: 0,
                                bottomRight: 0,
                                topLeft: 0,
                                topRight: 0,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 200,
                            height: 20,
                            child: Text(
                              posts[index].title,
                              maxLines: 1,
                              style: GoogleFonts.alexandria(
                                fontSize: 12,
                                color: Colors.white,
                                height: 1.7,
                              ),
                              overflow: TextOverflow.ellipsis,
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
        ),
      ),
    ],
  );
}
