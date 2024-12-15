import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/assets_manager.dart';
import '../../../../../core/app_styles/app_syles.dart';

class WatchlistItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String year;
  final String cast;

  const WatchlistItem({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.year,
    required this.cast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(4.r)),
                child: Image.network(
                  imageUrl,
                  width: 100.w,
                  height: 130.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                ),
              ),
              Positioned(
                top: 8.h,
                left: 8.w,
                child: Image.asset(
                  AssetsManager.saveIcon,
                  width: 24.w,
                  height: 24.h,
                ),
              ),
            ],
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyle.movieName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  year,
                  style: AppStyle.movieDetails,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  cast,
                  style: AppStyle.movieDetails,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
