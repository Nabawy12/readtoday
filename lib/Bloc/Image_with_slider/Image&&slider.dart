// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Imageheight extends StatelessWidget {
  final String imageUrl;

  // Constructor to accept the image URL
  const Imageheight({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Image.network(
      imageUrl,
      fit: BoxFit.fill,
      alignment: AlignmentDirectional.center,
      width: double.infinity,
      height: screenHeight * 0.5,
      loadingBuilder: (
        BuildContext context,
        Widget child,
        ImageChunkEvent? loadingProgress,
      ) {
        if (loadingProgress == null) {
          return child;
        } else {
          return SizedBox(width: double.infinity, height: screenHeight * 0.5);
        }
      },
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(width: double.infinity, height: screenHeight * 0.5);
      },
    );
  }
}

class containergradientcolor extends StatelessWidget {
  final Color color1;
  final Color color12;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const containergradientcolor({
    super.key,
    required this.color1,
    required this.color12,
    required this.begin,
    required this.end,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              tileMode: TileMode.mirror,
              transform: GradientRotation(0),
              begin: begin,
              end: end,
              colors: [
                color1,
                Colors.black12.withValues(alpha: 0.9),
                Colors.black12.withValues(alpha: 0.7),
                Colors.black12.withValues(alpha: 0.5),
                Colors.black12.withValues(alpha: 0.2),
                color12,
                color12,
              ],
            ),
          ),
        );
      },
    );
  }
}

class texttitlefornews extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final Color colorcirclecontainer;
  final IconData icon;
  final Color coloricon;

  const texttitlefornews({
    super.key,
    required this.text,
    required this.colorcirclecontainer,
    required this.icon,
    required this.coloricon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.01), // Responsive padding
          decoration: BoxDecoration(
            color: colorcirclecontainer,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: screenWidth * 0.01), // Responsive spacing
        InkWell(
          onTap: onTap,
          child: Text(
            text,
            style: GoogleFonts.alexandria(
              shadows: [
                Shadow(
                  color: Colors.black12.withValues(alpha: 0.8),
                  // Shadow color
                  offset: Offset(2, 2),
                  // Horizontal and vertical offset
                  blurRadius: 4, // Softness of the shadow
                ),
              ],
              fontSize: 16, // Responsive font size
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.005), // Responsive spacing
      ],
    );
  }
}
