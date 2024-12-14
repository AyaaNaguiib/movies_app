import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies_app/core/assets_manager.dart';
import 'package:movies_app/core/colors_manager.dart';
import '../movie_details/movie__details.dart';

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

  Future<void> _checkIfAdded() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('watchlist')
        .doc(widget.movieId.toString())
        .get();

    setState(() {
      isAdded = snapshot.exists;
    });
  }

  void toggleAddState() async {
    setState(() {
      isAdded = !isAdded;
    });

    if (isAdded) {
      await FirebaseFirestore.instance.collection('watchlist').doc(widget.movieId.toString()).set({
        'title': widget.title,
        'movieId': widget.movieId,
        'imageUrl': widget.imageUrl,
      });
    } else {

      await FirebaseFirestore.instance
          .collection('watchlist')
          .doc(widget.movieId.toString())
          .delete();
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


