// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:movies_app/core/colors_manager.dart';
// import '../movie_details/movie__details.dart';
// import '../movie_details/widgets/movie_details_API.dart';
//
// class NewReleaseCard extends StatefulWidget {
//   final String imageUrl;
//   final String title;
//   final int movieId;
//   const NewReleaseCard({
//     Key? key,
//     required this.imageUrl,
//     required this.title,
//     required this.movieId
//   }) : super(key: key);
//
//   @override
//   State<NewReleaseCard> createState() => _NewReleaseCardState();
// }
//
// class _NewReleaseCardState extends State<NewReleaseCard> {
//
//
//   bool isAdded = false;
//
//   void toggleAddState() {
//     setState(() {
//       isAdded = !isAdded;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => MovieDetails(movieId: widget.movieId),
//           ),
//         );
//       },
//       child: Container(
//         width: 120.w,
//         margin: EdgeInsets.only(right: 16.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12.r),
//                   child: Image.network(
//                     widget.imageUrl,
//                     height: 150.h,
//                     width: 120.w,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Positioned(
//                   top: 8.h,
//                   left: 8.w, // Updated position to left
//                   child: GestureDetector(
//                     onTap: toggleAddState,
//                     child: Image.asset(
//                       isAdded
//                           ? 'assets/images/bookmark (1).png'
//                           : 'assets/images/bookmark.png',
//                       height: 32.h,
//                       width: 24.w,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8.h),
//             Text(
//               widget.title,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.bold,
//                 color: ColorsManager.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies_app/core/colors_manager.dart';
import '../movie_details/movie__details.dart';
import '../movie_details/widgets/movie_details_API.dart';

class NewReleaseCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final int movieId;

  const NewReleaseCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.movieId,
  }) : super(key: key);

  @override
  State<NewReleaseCard> createState() => _NewReleaseCardState();
}

class _NewReleaseCardState extends State<NewReleaseCard> {
  bool isAdded = false;

  @override
  void initState() {
    super.initState();
    _checkIfAdded();
  }

  // Check if the movie is already added to the watchlist
  Future<void> _checkIfAdded() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('watchlist')
        .doc(widget.movieId.toString())
        .get();

    if (snapshot.exists) {
      setState(() {
        isAdded = true;
      });
    }
  }

  // Function to toggle add/remove movie from watchlist
  void toggleAddState() async {
    if (isAdded) {
      // If already added, remove from watchlist
      await FirebaseFirestore.instance
          .collection('watchlist')
          .doc(widget.movieId.toString())
          .delete();
    } else {
      // If not added, add to watchlist
      await FirebaseFirestore.instance.collection('watchlist').doc(widget.movieId.toString()).set({
        'title': widget.title,
        'movieId': widget.movieId,
        'imageUrl': widget.imageUrl,
      });
    }

    setState(() {
      isAdded = !isAdded; // Toggle the isAdded state
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetails(movieId: widget.movieId),
          ),
        );
      },
      child: Container(
        width: 120.w,
        margin: EdgeInsets.only(right: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    widget.imageUrl,
                    height: 150.h,
                    width: 120.w,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: GestureDetector(
                    onTap: toggleAddState,
                    child: Image.asset(
                      isAdded
                          ? 'assets/images/bookmark (1).png' // Checked icon
                          : 'assets/images/bookmark.png', // Add icon
                      height: 32.h,
                      width: 24.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              widget.title,
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
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:movies_app/core/colors_manager.dart';
// import '../movie_details/movie__details.dart';
// import '../movie_details/widgets/movie_details_API.dart';
//
// class NewReleaseCard extends StatefulWidget {
//   final String imageUrl;
//   final String title;
//   final int movieId;
//   //final String moviePosterUrl; // Additional parameter for movie poster URL
//
//   const NewReleaseCard({
//     Key? key,
//     required this.imageUrl,
//     required this.title,
//     required this.movieId,
//     //required this.moviePosterUrl, // Accept movie poster URL
//   }) : super(key: key);
//
//   @override
//   State<NewReleaseCard> createState() => _NewReleaseCardState();
// }
//
// class _NewReleaseCardState extends State<NewReleaseCard> {
//   bool isAdded = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkIfAdded();
//   }
//
//   // Check if the movie is already added to the watchlist
//   Future<void> _checkIfAdded() async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('watchlist')
//         .doc(widget.movieId.toString())
//         .get();
//
//     if (snapshot.exists) {
//       setState(() {
//         isAdded = true;
//       });
//     }
//   }
//
//   // Function to toggle add/remove movie from watchlist
//   void toggleAddState() async {
//     if (isAdded) {
//       // If already added, remove from watchlist
//       await FirebaseFirestore.instance
//           .collection('watchlist')
//           .doc(widget.movieId.toString())
//           .delete();
//     } else {
//       // If not added, add to watchlist
//       await FirebaseFirestore.instance.collection('watchlist').doc(widget.movieId.toString()).set({
//         'title': widget.title,
//         'movieId': widget.movieId,
//         'imageUrl': widget.imageUrl,
//         //'moviePosterUrl': widget.moviePosterUrl,
//       });
//     }
//
//     setState(() {
//       isAdded = !isAdded; // Toggle the isAdded state
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => MovieDetails(movieId: widget.movieId),
//           ),
//         );
//       },
//       child: Container(
//         width: 120.w,
//         margin: EdgeInsets.only(right: 16.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12.r),
//                   child: Image.network(
//                     widget.imageUrl,
//                     height: 150.h,
//                     width: 120.w,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Positioned(
//                   top: 8.h,
//                   left: 8.w, // Updated position to left
//                   child: GestureDetector(
//                     onTap: toggleAddState,
//                     child: Image.asset(
//                       isAdded
//                           ? 'assets/images/bookmark (1).png' // Checked icon
//                           : 'assets/images/bookmark.png', // Add icon
//                       height: 32.h,
//                       width: 24.w,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8.h),
//             Text(
//               widget.title,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.bold,
//                 color: ColorsManager.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
