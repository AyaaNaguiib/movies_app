import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/assets_manager.dart';
import 'package:movies_app/core/colors_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../movie_details/movie__details.dart';

class RecommendedCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String rating;
  final String runtime;
  final int movieId;

  const RecommendedCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.runtime,
    required this.movieId,
  }) : super(key: key);

  @override
  State<RecommendedCard> createState() => _RecommendedCardState();
}

class _RecommendedCardState extends State<RecommendedCard> {
  bool isAdded = false;

  @override
  void initState() {
    super.initState();
    _checkWatchlistStatus();
  }

  Future<void> _checkWatchlistStatus() async {
    final watchlist = await FirebaseFirestore.instance.collection('watchlist').get();
    final movieInWatchlist = watchlist.docs.any((doc) => doc['movieId'] == widget.movieId);
    setState(() {
      isAdded = movieInWatchlist;
    });
  }

  Future<void> _toggleWatchlist() async {
    setState(() {
      isAdded = !isAdded;
    });

    if (isAdded) {

      await FirebaseFirestore.instance.collection('watchlist').add({
        'movieId': widget.movieId,
        'title': widget.title,
        'imageUrl': widget.imageUrl,
        'rating': widget.rating,
        'runtime': widget.runtime,
      });
    } else {
      final query = await FirebaseFirestore.instance
          .collection('watchlist')
          .where('movieId', isEqualTo: widget.movieId)
          .get();

      for (var doc in query.docs) {
        await doc.reference.delete();
      }
    }
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
        width: 140.w,
        margin: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          color: ColorsManager.recommendedCard,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                  child: Image.network(
                    widget.imageUrl,
                    height: 180.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: GestureDetector(
                    onTap: _toggleWatchlist,
                    child: Image.asset(
                      isAdded
                          ? AssetsManager.saveIcon
                          : AssetsManager.addIcon,
                      height: 32.h,
                      width: 24.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, size: 14.sp, color: ColorsManager.yellow),
                      SizedBox(width: 4.w),
                      Text(
                        widget.rating,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: ColorsManager.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    widget.title,
                    maxLines: 2,
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
      ),
    );
  }
}


