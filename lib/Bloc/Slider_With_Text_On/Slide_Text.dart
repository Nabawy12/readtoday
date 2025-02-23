import 'package:flutter/material.dart';

class pageview extends StatelessWidget {
  final String images;
  final String titles;
  final PageController controller;
  final int itemcount;

  const pageview({
    super.key,
    required this.images,
    required this.titles,
    required this.controller,
    required this.itemcount,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      reverse: false,
      controller: controller,
      padEnds: false,
      itemCount: itemcount,
      // Use the length of the images list
      itemBuilder: (context, index) {
        EdgeInsets itemMargin;
        if (index == 0) {
          itemMargin = const EdgeInsets.only(right: 3, left: 5);
        } else {
          itemMargin = const EdgeInsets.symmetric(horizontal: 5);
        }

        return Container(
          margin: itemMargin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  // Image of the carousel
                  Image.network(
                    images,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 140,
                  ),
                  // Text overlay at the bottom of the image
                  Positioned(
                    bottom: 5,
                    left: 10,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black12.withValues(alpha: 0.5),
                      ),
                      child: Text(
                        titles,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Asharq',
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
