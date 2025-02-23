import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget Image_style({
  required bool network,
  bool asset = false,
  String? url,
  String? path,
  double? bottomLeft,
  double? bottomRight,
  double? topLeft,
  double? topRight,
  BoxFit? fit,
  double? height,
  double? minHeight,
  double? width,
}) {
  return ClipRRect(
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(10),
      topLeft: Radius.circular(10),
      topRight: Radius.circular(10),
    ),
    child: (url != null &&
            url.isNotEmpty &&
            (url.startsWith('http://') || url.startsWith('https://')))
        ? Container(
            constraints: BoxConstraints(minHeight: minHeight ?? 0),
            child: Center(
              child: CachedNetworkImage(
                filterQuality: FilterQuality.high,
                errorWidget: (context, url, error) {
                  return Container(
                    width: double.infinity,
                    height: height,
                    constraints: BoxConstraints(minHeight: minHeight ?? 0),
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey[500],
                      size: 50,
                    ),
                  );
                },
                progressIndicatorBuilder: (context, url, progress) {
                  return Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    height: minHeight ?? 0,
                    width: double.infinity,
                  );
                },
                imageUrl: url,
                fit: BoxFit.cover,
                height: height,
                width: width,
              ),
            ),
          )
        : Container(
            width: width,
            height: height,
            constraints: BoxConstraints(minHeight: minHeight ?? 0),
            color: Colors.grey[200],
            child: Icon(
              Icons.image_not_supported_outlined,
              color: Colors.grey[500],
              size: 50,
            ),
          ),
  );
}
