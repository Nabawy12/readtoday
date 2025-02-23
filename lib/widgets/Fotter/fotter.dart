import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget footer({
  required String image,
  required String text,
  required String text_social,
  required bool show_text,
  required bool show_logo,
  required bool show_socil,
  void Function()? onTap_facebook,
  void Function()? onTap_twitter,
  void Function()? onTap_linkedIn,
  void Function()? onTap_instgrame,
  void Function()? onTap_tiktok,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 13.0),
    child: Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          show_socil == true
              ? show_logo == true
                  ? Image.network(
                    image,
                    width: 120,
                    loadingBuilder: (
                      BuildContext context,
                      Widget child,
                      ImageChunkEvent? loadingProgress,
                    ) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return const SizedBox(
                          width: 120, // Same width as logo
                          height: 0, // Adjust height as necessary
                        );
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 120,
                      ); // Show error icon if image fails to load
                    },
                  )
                  : Container()
              : Container(),
          const SizedBox(height: 15),
          show_text == true
              ? Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.alexandria(
                  fontSize: 12,
                  height: 1.7,
                  color: Colors.grey[800],
                ),
              )
              : Container(),
          const SizedBox(height: 20),
          show_socil == true
              ? Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text_social,
                      style: GoogleFonts.alexandria(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          overlayColor: const WidgetStatePropertyAll(
                            Colors.white,
                          ),
                          onTap: onTap_facebook,
                          child: const Icon(
                            FontAwesomeIcons.facebook,
                            color: Color(0xff4d69a1),
                            size: 27,
                          ),
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          overlayColor: const WidgetStatePropertyAll(
                            Colors.white,
                          ),
                          onTap: onTap_twitter,
                          child: const Icon(
                            FontAwesomeIcons.xTwitter,
                            color: Colors.black,
                            size: 27,
                          ),
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          overlayColor: const WidgetStatePropertyAll(
                            Colors.white,
                          ),
                          onTap: onTap_linkedIn,
                          child: const Icon(
                            FontAwesomeIcons.linkedinIn,
                            color: Color(0xff126bc4),
                            size: 27,
                          ),
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          overlayColor: const WidgetStatePropertyAll(
                            Colors.white,
                          ),
                          onTap: onTap_instgrame,
                          child: const Icon(
                            FontAwesomeIcons.instagram,
                            color: Color(0xffdd359a),
                            size: 27,
                          ),
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          overlayColor: const WidgetStatePropertyAll(
                            Colors.white,
                          ),
                          onTap: onTap_tiktok,
                          child: const Icon(
                            FontAwesomeIcons.tiktok,
                            color: Colors.black,
                            size: 27,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              )
              : Container(),
        ],
      ),
    ),
  );
}
