import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget recommendedSection(String title, bool center, void Function()? onTap) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:
          center == true ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Text with custom style

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 5,
            ),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.alexandria(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                height: 1.7,
              ),
            ),
/*
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 3),
                height: 1.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black12.withOpacity(0.2),
                      Colors.black12.withOpacity(0.2),
                      Colors.black12.withOpacity(0.0),
                    ],
                    begin: Alignment.centerRight, // بدأ من اليمين
                    end: Alignment.centerLeft, // انتهى لليسار
                  ),
                ),
              ),
            ),
*/
            const Spacer(),
            InkWell(
              overlayColor: const WidgetStatePropertyAll(Colors.white),
              onTap: onTap,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "المزيد",
                    style: GoogleFonts.alexandria(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      height: 1.7,
                      color: const Color(0xffC62326),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Color(0xffC62326),
                    size: 14,
                  )
                ],
              ),
            )
          ],
        ),
      ],
    ),
  );
}
