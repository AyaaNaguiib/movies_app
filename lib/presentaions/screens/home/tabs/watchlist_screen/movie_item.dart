// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:movies_app/core/assets_manager.dart';
// import '../../../../../core/app_styles/app_syles.dart';
//
// class WatchlistItem extends StatelessWidget {
//   const WatchlistItem({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:  REdgeInsets.symmetric(vertical: 16),
//       child: Row(
//         children: [
//           ClipRRect(
//               borderRadius: BorderRadius.all(Radius.circular(4.r)),
//               child: Image.asset(
//                 AssetsManager.categoryItem,
//                 width: 140.w,
//                 height: 89.h,
//               )),
//           SizedBox(
//             width: 10.w,
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Alita Battle Angel',
//                 style: AppStyle.movieName,
//               ),
//               Text(
//                 '2019',
//                 style: AppStyle.movieDetails,
//               ),
//               Text(
//                 'Rosa Salazar, Christoph Waltz',
//                 style: AppStyle.movieDetails,
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
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
          // Ensure image fits within constraints without overflowing
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4.r)),
            child: Image.network(
              imageUrl,
              width: 140.w,
              height: 89.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error); // Display an error icon if image fails to load
              },
            ),
          ),
          SizedBox(width: 10.w),
          // Wrap the text in a Column with constraints to avoid overflow
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title text, truncated with ellipsis if it overflows
                Text(
                  title,
                  style: AppStyle.movieName,
                  overflow: TextOverflow.ellipsis, // Prevent overflow for long titles
                  maxLines: 1,
                ),
                // Year text
                Text(
                  year,
                  style: AppStyle.movieDetails,
                  overflow: TextOverflow.ellipsis, // Prevent overflow for year text
                  maxLines: 1,
                ),
                // Cast text
                Text(
                  cast,
                  style: AppStyle.movieDetails,
                  overflow: TextOverflow.ellipsis, // Prevent overflow for cast text
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

