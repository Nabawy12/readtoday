import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget autoslider({
  required List<String> titlelist,
  required List<String> datelist,
  required PageController pageController,
  required int currentPage,
  required void Function() startAutoScroll,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;

      // بدء التمرير التلقائي
      startAutoScroll();

      return SizedBox(
        height: screenHeight * 0.15, // Adjusted height relative to screen
        width: double.infinity,
        child: PageView.builder(
          controller: pageController,
          itemCount: titlelist.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: EdgeInsets.all(screenWidth * 0.025),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xffe5eaef)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.grey,
                            size: screenWidth * 0.05, // Responsive icon size
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          Text(
                            datelist[index],
                            style: GoogleFonts.alexandria(
                              color: Colors.grey,
                              fontSize:
                                  screenWidth * 0.025, // Responsive font size
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: screenWidth * 0.5, // Responsive width
                        ),
                        child: Text(
                          titlelist[index],
                          textAlign: TextAlign.start,
                          softWrap: true,
                          maxLines: 2,
                          style: GoogleFonts.alexandria(
                            fontSize:
                                screenWidth * 0.03, // Responsive font size
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
