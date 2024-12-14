// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:movies_app/core/colors_manager.dart';
// import '../movie__details.dart';
//
// class MoreLikeThis extends StatefulWidget {
//   final Future<List<dynamic>> similarMoviesFuture;
//   const MoreLikeThis({Key? key, required this.similarMoviesFuture})
//       : super(key: key);
//
//   @override
//   State<MoreLikeThis> createState() => _MoreLikeThisState();
// }
//
// class _MoreLikeThisState extends State<MoreLikeThis> {
//   bool isAdded = false;
//
//   void toggleAddState() {
//     setState(() {
//       isAdded = !isAdded;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const baseUrl = "https://image.tmdb.org/t/p/w500";
//
//     return FutureBuilder<List<dynamic>>(
//       future: widget.similarMoviesFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else {
//           final movies = snapshot.data!;
//           return Container(
//             width: double.infinity,
//             margin: EdgeInsets.symmetric(horizontal: 0),
//             padding: EdgeInsets.all(10.w),
//             decoration: BoxDecoration(
//               color: ColorsManager.grey,
//               borderRadius: BorderRadius.circular(5.r),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "More Like This",
//                   style: TextStyle(
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.bold,
//                     color: ColorsManager.white,
//                   ),
//                 ),
//                 SizedBox(height: 10.h),
//                 SizedBox(
//                   height: 220.h,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: movies.length,
//                     itemBuilder: (context, index) {
//                       final movie = movies[index];
//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   MovieDetails(movieId: movie['id']),
//                             ),
//                           );
//                         },
//                         child: Card(
//                           margin: EdgeInsets.only(right: 5.w),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8.r),
//                           ),
//                           elevation: 3,
//                           color: ColorsManager.recommendedCard,
//                           child: Container(
//                             width: 120.w,
//                             child: Stack(
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(8.r),
//                                         topRight: Radius.circular(8.r),
//                                       ),
//                                       child: Image.network(
//                                         "$baseUrl${movie['poster_path']}",
//                                         height: 150.h,
//                                         width: double.infinity,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.all(8.w),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Icon(
//                                                 Icons.star,
//                                                 size: 14.sp,
//                                                 color: ColorsManager.yellow,
//                                               ),
//                                               SizedBox(width: 5.w),
//                                               Text(
//                                                 movie['vote_average']
//                                                     .toStringAsFixed(1),
//                                                 style: TextStyle(
//                                                   fontSize: 12.sp,
//                                                   color: ColorsManager.white,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           SizedBox(height: 5.h),
//                                           Text(
//                                             movie['title'],
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: TextStyle(
//                                               fontSize: 14.sp,
//                                               fontWeight: FontWeight.bold,
//                                               color: ColorsManager.white,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Positioned(
//                                   top: 8.h,
//                                   left: 8.w,
//                                   child: GestureDetector(
//                                     onTap: toggleAddState,
//                                     child: Image.asset(
//                                       isAdded
//                                           ? 'assets/images/bookmark (1).png'
//                                           : 'assets/images/bookmark.png',
//                                       height: 20.h,
//                                       width: 24.w,
//                                       fit: BoxFit.contain,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/colors_manager.dart';
import '../movie__details.dart';
import 'movie_details_API.dart';

class MoreLikeThis extends StatefulWidget {
  final Future<List<dynamic>> similarMoviesFuture;
  const MoreLikeThis({Key? key, required this.similarMoviesFuture}) : super(key: key);

  @override
  State<MoreLikeThis> createState() => _MoreLikeThisState();
}

class _MoreLikeThisState extends State<MoreLikeThis> {
  Map<int, bool> movieBookmarkState = {};

  void toggleAddState(int movieId, Map<String, dynamic> movie) {
    setState(() {
      movieBookmarkState[movieId] = !(movieBookmarkState[movieId] ?? false);

      if (movieBookmarkState[movieId]!) {
        MovieService.addToWatchlist(movie);
      } else {
        MovieService.removeFromWatchlist(movieId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const baseUrl = "https://image.tmdb.org/t/p/w500";

    return FutureBuilder<List<dynamic>>(
      future: widget.similarMoviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final movies = snapshot.data!;
          return Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 0),
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: ColorsManager.grey,
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "More Like This",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.white,
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 220.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      final isAdded = movieBookmarkState[movie['id']] ?? false; // Check the bookmark state for this movie
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetails(movieId: movie['id']),
                            ),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.only(right: 5.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          elevation: 3,
                          color: ColorsManager.recommendedCard,
                          child: Container(
                            width: 120.w,
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.r),
                                        topRight: Radius.circular(8.r),
                                      ),
                                      child: Image.network(
                                        "$baseUrl${movie['poster_path']}",
                                        height: 150.h,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.w),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 14.sp,
                                                color: ColorsManager.yellow,
                                              ),
                                              SizedBox(width: 5.w),
                                              Text(
                                                movie['vote_average']
                                                    .toStringAsFixed(1),
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: ColorsManager.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h),
                                          Text(
                                            movie['title'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              color: ColorsManager.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 8.h,
                                  left: 8.w,
                                  child: GestureDetector(
                                    onTap: () => toggleAddState(movie['id'], movie),
                                    child: Image.asset(
                                      isAdded
                                          ? 'assets/images/bookmark (1).png'
                                          : 'assets/images/bookmark.png',
                                      height: 20.h,
                                      width: 24.w,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
