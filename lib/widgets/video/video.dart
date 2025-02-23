import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customColumn({
  required List<Map<String, dynamic>>
      secondPosts, // List of maps containing image URLs and titles
  required String svgAssetPath, // Path to the SVG asset
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SvgPicture.asset(
          svgAssetPath,
          width: 70,
          height: 25,
        ),
      ),
      const SizedBox(height: 10),
      Container(
        height: 200,
        decoration: const BoxDecoration(
          color: Color(0xff141e28),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:
                    secondPosts.length, // Use the length of the list here
                itemBuilder: (context, index) {
                  final secondpost = secondPosts[index]; // Get current post

                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 13.0, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Image.network(
                              secondpost[
                                  'image'], // Dynamically load the image URL
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              left: 0,
                              bottom: 0,
                              child: Container(
                                width: 24.0,
                                height: 24.0,
                                margin: const EdgeInsets.all(4),
                                padding: const EdgeInsets.all(4),
                                color: const Color(0xffC62326),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white38.withOpacity(0.2),
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Text(
                                  secondpost['duration'],
                                  // Dynamically load the video duration
                                  style: GoogleFonts.alexandria(
                                    fontSize: 10,
                                    color: Colors.white,
                                    height: 1.7,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 200,
                          child: Text(
                            secondpost['title'],
                            style: GoogleFonts.alexandria(
                              fontSize: 14,
                              color: Colors.white,
                              height: 1.7,
                            ),
                            maxLines: 2,
                            softWrap: true,
                          ),
                        ),
                      ],
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
