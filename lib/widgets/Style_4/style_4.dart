import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildHeader_new_news({
  required String title, // Main title, e.g., "اخر الأخبار"
  required String subtitle, // Subtitle, e.g., "تابع المزيد"
}) {
  return Column(
    children: [
      // Divider
      Container(
        height: 1.5,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xffc62326), // Red color for divider
        ),
      ),
      // Header container with row
      Container(
        height: 40,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.black, // Black background for header
        ),
        child: Row(
          children: [
            const SizedBox(width: 25),
            // Title Text
            Text(
              title,
              style: GoogleFonts.alexandria(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.6,
              ),
            ),
            const Spacer(),
            // Subtitle Text
            Text(
              subtitle,
              style: GoogleFonts.alexandria(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
                height: 1.6,
              ),
            ),
            // Arrow Icon
            const Icon(Icons.arrow_forward_ios_outlined,
                color: Color(0xffc62326)),
            const SizedBox(width: 10),
          ],
        ),
      ),
    ],
  );
}
