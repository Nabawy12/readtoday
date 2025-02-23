import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget ButtonLoader({
  required String text,
  required VoidCallback onTap,
}) {
  return InkWell(
    hoverColor: Colors.transparent,
    splashColor: Colors.transparent,
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 80),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xffC62326),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.category_rounded, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            text,
            style: GoogleFonts.alexandria(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}
