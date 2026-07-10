import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class JumShimmer extends StatelessWidget {
  final Widget child;

  const JumShimmer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.surface2,
      child: child,
    );
  }

  // Factory constructor for Card Shimmer
  static Widget card({double height = AppSizes.cardHeight}) {
    return JumShimmer(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
      ),
    );
  }

  // Factory constructor for Avatar Shimmer
  static Widget avatar({double size = AppSizes.avatarMd}) {
    return JumShimmer(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  // Factory constructor for ListTile Shimmer
  static Widget listTile() {
    return JumShimmer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingSm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: AppSizes.avatarMd,
              height: AppSizes.avatarMd,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSizes.paddingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 140,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingXs),
                  Container(
                    width: 200,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Factory constructor for list of ListTiles Shimmer
  static Widget list({int count = 5}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (context, index) => listTile(),
    );
  }
}

class JumShimmerList extends StatelessWidget {
  final int itemCount;
  const JumShimmerList({Key? key, this.itemCount = 3}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: JumShimmer.card(height: 80),
      ),
    );
  }
}

class JumShimmerGrid extends StatelessWidget {
  final int itemCount;
  const JumShimmerGrid({Key? key, this.itemCount = 4}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => JumShimmer.card(height: 120),
    );
  }
}
