import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class Skeleton_archive extends StatelessWidget {
  final int? itemcount;

  const Skeleton_archive({super.key, this.itemcount});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),

      shrinkWrap: true,
      itemCount: itemcount == 0 ? 5 : itemcount, // Number of skeleton items
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SkeletonItem(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    height: 200,
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 15),
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 16,
                    width: 200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 10),
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 14,
                    width: 150,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
