import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../YC Style/Image.dart';

Widget customSection_list({
  required String category,
  required String subtitle,
  required String imageUrl,
  required Color titleColor,
  required Color subtitleColor,
  required void Function()? onTap,
  Color? rankColor, // Make rankColor optional to avoid issues when rank is null
  required Color imageBorderColor,
}) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
        decoration: BoxDecoration(
          // color: Color(0xfff6f5fa),
          border: Border.all(color: const Color(0xffe5eaef)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image_style(
                    topLeft: 0,
                    topRight: 0,
                    bottomLeft: 0,
                    bottomRight: 0,
                    network: true,
                    url: imageUrl,
                    height: 90,
                    width: 100,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        category.isNotEmpty
                            ? InkWell(
                              onTap: onTap,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xffc62326),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child:
                                    category.isNotEmpty
                                        ? HtmlWidget(
                                          category,
                                          textStyle: GoogleFonts.alexandria(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        )
                                        : Container(),
                              ),
                            )
                            : Container(),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            subtitle,
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.alexandria(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: subtitleColor,
                              height: 1.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
