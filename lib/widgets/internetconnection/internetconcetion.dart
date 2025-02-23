import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/widgets.dart';

import '../../Constants/color.dart';

Widget noInternetConnectionWidget(VoidCallback retryCallback) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              width: 250,
              child: Gif(
                autostart: Autostart.loop,
                image: const AssetImage('assets/images/No_connection.gif'),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "لا يوجد اتصال بالأنترنت",
              style: GoogleFonts.alexandria(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade300,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: retryCallback,
              child: Text(
                "اعاده المحاوله",
                style: GoogleFonts.alexandria(
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colorss().MainColor,
                // You can change it to Colorss().MainColor if available
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
