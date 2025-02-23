import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class CustomContentSkeleton extends StatelessWidget {
  const CustomContentSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        SkeletonParagraph(
          style: SkeletonParagraphStyle(
            lines: 1,
            spacing: 6,
            lineStyle: SkeletonLineStyle(
              height: 20,
              randomLength: true,
              minLength: 50,
              // تأكد من توافق طول الخط
              maxLength: 55,
              borderRadius: BorderRadius.circular(
                5,
              ), // مشابه لما في الـ CustomContentWidget
            ),
          ),
        ),
        const SizedBox(height: 5),
        SkeletonParagraph(
          style: SkeletonParagraphStyle(
            lines: 2,
            spacing: 5,
            lineStyle: SkeletonLineStyle(
              height: 15,
              randomLength: true,
              minLength: 200,
              // نفس طول العنوان في الـ CustomContentWidget
              maxLength: 300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            const SizedBox(width: 10),
            const SkeletonAvatar(
              style: SkeletonAvatarStyle(
                width: 40,
                height: 40,
                shape: BoxShape.rectangle,
              ),
            ),
            const Spacer(),
            SkeletonParagraph(
              style: SkeletonParagraphStyle(
                lines: 1,
                spacing: 6,
                lineStyle: SkeletonLineStyle(
                  height: 40,
                  randomLength: true,
                  minLength: 120,
                  maxLength: 150,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: SkeletonAvatar(
            style: SkeletonAvatarStyle(
              width: double.infinity,
              height: 200,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            SkeletonParagraph(
              style: const SkeletonParagraphStyle(
                lines: 1,
                spacing: 6,
                lineStyle: SkeletonLineStyle(
                  height: 15,
                  randomLength: true,
                  minLength: 40,
                  maxLength: 60,
                ),
              ),
            ),
            SkeletonParagraph(
              style: const SkeletonParagraphStyle(
                lines: 1,
                spacing: 6,
                lineStyle: SkeletonLineStyle(
                  height: 15,
                  randomLength: true,
                  minLength: 80,
                  maxLength: 100,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SkeletonParagraph(
          style: SkeletonParagraphStyle(
            lines: 4,
            spacing: 6,
            lineStyle: SkeletonLineStyle(
              height: 14,
              randomLength: true,
              minLength: 300,
              maxLength: 500,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
