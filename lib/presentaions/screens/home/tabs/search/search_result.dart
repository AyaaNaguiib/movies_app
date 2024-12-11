import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/colors_manager.dart';

class SearchResultItem extends StatelessWidget {
  final dynamic movie;
  final String baseUrl;

  const SearchResultItem({
    Key? key,
    required this.movie,
    required this.baseUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: movie['poster_path'] != null
                ? Image.network(
              "$baseUrl${movie['poster_path']}",
              width: 110.w,
              height: 90.h,
              fit: BoxFit.fitWidth,
            )
                : Container(
              width: 110.w,
              height: 90.h,
              color: ColorsManager.grey,
              child: Icon(Icons.movie,
                  color: ColorsManager.localMoviesIcon, size: 40.sp),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5.h),
                Text(
                  movie['release_date']?.split('-')[0] ?? 'Unknown Year',
                  style: TextStyle(
                    color: ColorsManager.white.withOpacity(0.67),
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

