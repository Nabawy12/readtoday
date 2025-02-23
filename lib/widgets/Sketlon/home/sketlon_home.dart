import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class NewsSkeletonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Main News Section
          Container(
            height: 250,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    width: double.infinity,
                    height: double.infinity,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.black12,
                    child: SkeletonParagraph(
                      style: SkeletonParagraphStyle(
                        lines: 2,
                        spacing: 5,
                        lineStyle: SkeletonLineStyle(
                          height: 12,
                          width: MediaQuery.of(context).size.width * 0.8,
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Horizontal Scrolling Section (Sub-news)
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SkeletonParagraph(
                    style: SkeletonParagraphStyle(
                      lines: 2,
                      spacing: 4,
                      lineStyle: SkeletonLineStyle(
                        height: 8,
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // Grid Section for News
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: SkeletonParagraph(
                    style: SkeletonParagraphStyle(
                      lines: 2,
                      spacing: 5,
                      lineStyle: SkeletonLineStyle(
                        height: 10,
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
