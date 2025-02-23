import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../YC Style/Image.dart';
import '../../screens/archive/archive.dart';

class SingleSection extends StatelessWidget {
  final String imageUrl;
  final Function()? onTap;
  final String category;
  final String cleanTitle1;
  final String cleanContent;
  final int idCategory;
  final String Name;
  final String shape;

  const SingleSection({
    super.key,
    required this.imageUrl,
    required this.category,
    required this.cleanTitle1,
    required this.cleanContent,
    required this.onTap,
    required this.idCategory,
    required this.Name,
    required this.shape,
  });

  @override
  Widget build(BuildContext context) {
    // Fetch screen dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffe5eaef)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container
            if (imageUrl.isNotEmpty)
              Image_style(
                network: true,
                bottomRight: 0,
                bottomLeft: 0,
                topRight: 0,
                topLeft: 0,
                url: imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: screenHeight * 0.25,
              ),
            if (imageUrl.isNotEmpty)
              SizedBox(height: screenHeight * 0.01), // Responsive spacing
            // Category text
            if (category.isNotEmpty)
              InkWell(
                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
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
                            title_show: true,
                            id: idCategory,
                            name: Name,
                          ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffc62326),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    category,
                    style: GoogleFonts.alexandria(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      height: 1.8,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 5),
            // Title text
            if (cleanTitle1.isNotEmpty)
              Text(
                cleanTitle1,
                style: GoogleFonts.alexandria(
                  color: Colors.black,
                  height: 1.9,
                  fontSize: screenWidth * 0.05, // Responsive font size
                  fontWeight: FontWeight.w900,
                ),
              ),

            // Content text
            if (cleanContent.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(
                  top: screenHeight * 0.015,
                ), // Responsive padding
                child: HtmlWidget(
                  cleanContent,
                  textStyle: GoogleFonts.alexandria(
                    color: Colors.black54,
                    height: 1.7,
                    fontSize: 15, // Responsive font size
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
