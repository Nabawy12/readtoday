import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // عدد الأعمدة
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8, // تصغير الارتفاع مقارنة بالعرض
        ),
        itemCount: 10,
        itemBuilder: (context, index) => const SkeletonServiceCard(),
      ),
    );
  }
}

class SkeletonServiceCard extends StatelessWidget {
  const SkeletonServiceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffe5eaef)),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة وهمية
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SkeletonAvatar(
              style: SkeletonAvatarStyle(
                height: 120,
                width: double.infinity,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // عنوان القسم
          SkeletonLine(
            style: SkeletonLineStyle(
              height: 16,
              width: 80,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 7),

          // عنوان الخدمة
          SkeletonLine(
            style: SkeletonLineStyle(
              height: 16,
              width: 100,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}
